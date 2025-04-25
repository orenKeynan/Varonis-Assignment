data "azurerm_client_config" "this" {
}

locals {
  rg_name  = "rg-varonis"
  location = "East US"
  tags = {
    environment = "dev"
    owner       = "oren"
  }
}

module "rg" {
  source   = "./modules/resource_group"
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

# create password for sql admin user
resource "random_password" "sql_admin" {
  length  = 12
  special = true
}

module "kv_sql" {
  source = "./modules/key_vault_secret"
  key_vault_name   = "kv-sql-varonis-sql"
  object_id = data.azurerm_client_config.this.object_id
  tenant_id = data.azurerm_client_config.this.tenant_id
  location = module.rg.location
  resource_group_name = module.rg.name
  secret_name = "varonis-sql-admin-password"
  value = random_password.sql_admin.result
}

module "azure_sql" {
  source = "./modules/azure_sql"
  resource_group_name         = module.rg.name
  location                    = module.rg.location
  tenant_id                   = data.azurerm_client_config.this.tenant_id
  object_id                   = data.azurerm_client_config.this.object_id
  tags                        = local.tags
  sql_server_name             = "varonis-sql"
  administrator_login         = "sqladmin"
  administrator_login_password = random_password.sql_admin.result
  database_name               = "restaurants"
  sku_name                    = "GP_S_Gen5_1"
  max_size_gb                 = "2"
  min_capacity                = 0.5
  auto_pause_delay_in_minutes = 60
  minimum_tls_version         = "1.2"
  sql_version                 = "12.0"
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "demo-vnet"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.42.0.0/16"]

  subnets = {
    appgw = "10.42.1.0/24"
    app   = "10.42.2.0/24"
  }
}

module "logs_storage" {
  source              = "./modules/storage_account_storage"
  resource_group_name = local.rg_name
  location            = local.location
  sa_name             = "restaurants_logs"
  network_subnet_ids   = [module.network.subnet_ids["appgw"]]
}

module "container_app" {
  source                    = "./modules/container_app"
  app_name                  = "restaurants-api"
  location                  = local.location
  resource_group_name       = local.rg_name
  container_name = "rest-api"
  cpu = 0.5
  memory = 1.0
  subnet_id = module.network.subnet_ids["app"]
  image                     = "ghcr.io/you/restaurants:latest"
  logs_storage_account_id   = module.logs_storage.id
}

module "app_gw" {
  source              = "./modules/app_gw"
  app_gw_name         = "rest-gw"
  location            = local.location
  azure_key_id        = module.kv_sql.key_vault_id
  resource_group_name = local.rg_name
  sku_name            = "WAF_v2"
  capacity            = 1
  subnet_id           = module.network.subnet_ids["snet-ingress"]

  frontend_ports = {
    https = { name = "https", port = 443 }
  }

  frontend_ip_configs = {
    public = {
      name         = "public"
      public_ip_id = azurerm_public_ip.pip.id
    }
  }

  backend_pools = {
    api = { name = "api", fqdns = [module.container_app.container_app_fqdn] }
  }

  backend_http_settings = {
    api = {
      name  = "api"
      port  = 8000
      protocol = "Http"
      cookie_based_affinity = "Disabled"
      request_timeout       = 30
    }
  }

  http_listeners = {
    https = {
      name                           = "https-listener"
      frontend_ip_configuration_name = "public"
      frontend_port_name             = "https"
      protocol                       = "Https"
      ssl_certificate_name           = "kv-cert"
    }
  }

  request_routing_rules = {
    default = {
      name                       = "rule1"
      rule_type                  = "Basic"
      http_listener_name         = "https-listener"
      backend_address_pool_name  = "api"
      backend_http_settings_name = "api"
      priority                   = 1
    }
  }
}
