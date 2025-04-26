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
  source              = "./modules/key_vault"
  key_vault_name      = "kv-sql-varonis-sql"
  object_id           = data.azurerm_client_config.this.object_id
  tenant_id           = data.azurerm_client_config.this.tenant_id
  location            = module.rg.location
  resource_group_name = module.rg.name
  secret_name         = "varonis-sql-admin-password"
  value               = random_password.sql_admin.result
}

module "azure_sql" {
  source                       = "./modules/azure_sql"
  resource_group_name          = module.rg.name
  location                     = module.rg.location
  tenant_id                    = data.azurerm_client_config.this.tenant_id
  object_id                    = data.azurerm_client_config.this.object_id
  tags                         = local.tags
  key_vault_id                 = module.kv_sql.key_vault_id
  sql_server_name              = "varonis-sql"
  admin_secret_name            = "sqladmin"
  administrator_login          = "sqladmin"
  administrator_login_password = random_password.sql_admin.result
  database_name                = "restaurants"
  sku_name                     = "GP_S_Gen5_1"
  max_size_gb                  = "2"
  min_capacity                 = 0.5
  auto_pause_delay_in_minutes  = 60
  minimum_tls_version          = "1.2"
  sql_version                  = "12.0"
}

module "acr" {
  source                        = "./modules/docker_registry" # adjust path as needed
  acr_name                      = "varonishaacr"
  sku                           = "Premium"
  resource_group_name           = local.rg_name
  location                      = local.location
  admin_enabled                 = true                       # Should be false and research how we can push
  key_vault_id                  = module.kv_sql.key_vault_id # Not needed
  admin_secret_name             = "acr-admin-pass"
  public_network_access_enabled = true # should be false and set specific IPs. possible only when sku = premium
  tags                          = local.tags
}

module "service_account" {
  source              = "./modules/service_account"
  name                = "acr_user"
  secret_length       = 20
  secret_expire_hours = 168
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPush"
  principal_id         = module.service_account.object_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.service_account.object_id
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "rest-vnet"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.42.0.0/16"]

  subnets = {
    appgw = "10.42.0.0/23"
    app   = "10.42.2.0/23"
  }

  subnet_service_endpoints = {
    appgw = ["Microsoft.Storage"]
  }
}

module "logs_storage" {
  source              = "./modules/storage_account_storage"
  resource_group_name = local.rg_name
  location            = local.location
  sa_name             = "restaurantslogs"
  network_subnet_ids  = [module.network.subnet_ids["appgw"]]
}

module "container_app" {
  source                  = "./modules/container_app"
  app_name                = "restaurants-api"
  location                = local.location
  resource_group_name     = local.rg_name
  acr_login_server        = module.acr.login_server
  acr_username            = module.service_account.client_id
  acr_secret_name         = "acr-sp-secret"
  acr_secret_value        = module.service_account.client_secret
  container_name          = "rest-api"
  port                    = 8000
  cpu                     = 0.5
  memory                  = "1Gi"
  subnet_id               = module.network.subnet_ids["app"]
  image                   = "varonishaacr.azurecr.io/restaurant-app:latest"
}

resource "azurerm_public_ip" "pip" {
  name                = "rest"
  location            = local.location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "rest"
}

module "app_gw" {
  source              = "./modules/app_gw"
  app_gw_name         = "rest-gw"
  location            = local.location
  azure_key_id        = module.kv_sql.key_vault_id
  resource_group_name = local.rg_name
  sku_name            = "WAF_v2"
  capacity            = 1
  azurerm_public_fqdn = azurerm_public_ip.pip.fqdn
  subnet_id           = module.network.subnet_ids["appgw"]
  logs_storage_account_id = module.logs_storage.storage_account_id
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
    api = { name = "api", fqdn = [module.container_app.container_app_fqdn] }
  }

  backend_http_settings = {
    api = {
      name                  = "api"
      port                  = 8000
      protocol              = "Http"
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
