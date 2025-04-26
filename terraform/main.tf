data "azurerm_client_config" "this" {
}

locals {
  rg_name  = "rg-varonis"
  location = "East US"
  tags = {
    environment = "dev"
    owner       = "oren"
  }
  sql_admin_user = "sqladmin"
  port           = 8000
}

module "rg" {
  source   = "./modules/resource_group"
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

########################
# Creationg of network related conponents

module "network" {
  source              = "./modules/network"
  vnet_name           = "rest-vnet"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.42.0.0/16"]

  subnets = {
    appgw = {
      ip = "10.42.0.0/23"
    }
    app = {
      ip                                            = "10.42.2.0/23"
      private_link_service_network_policies_enabled = false
    }
  }

  subnet_service_endpoints = {
    appgw = ["Microsoft.Storage"]
    app   = ["Microsoft.Sql"]
  }
}


##################
# Creation of related sql components

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


module "pdns_sql" {
  source              = "./modules/private_dns"
  pdns_name           = "privatelink.database.windows.net"
  virtual_network_id  = module.network.vnet_id
  resource_group_name = local.rg_name

  # No static records — the SQL private-endpoint NIC auto-creates the A-record
  private_dns_a_records = {}
}

module "azure_sql" {
  source              = "./modules/azure_sql"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tenant_id           = data.azurerm_client_config.this.tenant_id
  object_id           = data.azurerm_client_config.this.object_id
  tags                = local.tags
  pdns_zone_id        = module.pdns_sql.zone_id
  private_endpoints = {
    app = module.network.subnet_ids["app"]
  }
  key_vault_id                 = module.kv_sql.key_vault_id
  sql_server_name              = "varonis-sql"
  admin_secret_name            = "sqladmin"
  administrator_login          = local.sql_admin_user
  administrator_login_password = random_password.sql_admin.result
  database_name                = "restaurants"
  sku_name                     = "GP_S_Gen5_1"
  max_size_gb                  = "2"
  min_capacity                 = 0.5
  auto_pause_delay_in_minutes  = 60
  minimum_tls_version          = "1.2"
  sql_version                  = "12.0"
}


###################
# Creation of ACR related resources
module "service_account" {
  source              = "./modules/service_account"
  name                = "acr_user"
  secret_length       = 20
  secret_expire_hours = 168
}

module "acr" {
  source                        = "./modules/docker_registry"
  acr_name                      = "varonishaacr"
  sku                           = "Premium"
  resource_group_name           = local.rg_name
  location                      = local.location
  service_account_id            = module.service_account.object_id
  admin_enabled                 = true                       # Should be false and research how we can push
  key_vault_id                  = module.kv_sql.key_vault_id # Not needed
  admin_secret_name             = "acr-admin-pass"
  public_network_access_enabled = true # should be false and set specific IPs. possible only when sku = premium
  tags                          = local.tags
}

########################
# Create container app related resources
module "logs_storage" {
  source              = "./modules/storage_account_storage"
  resource_group_name = local.rg_name
  location            = local.location
  sa_name             = "restaurantslogs"
  network_subnet_ids  = [module.network.subnet_ids["appgw"]]
}

module "container_app" {
  source              = "./modules/container_app"
  app_name            = "restaurants-api"
  location            = local.location
  resource_group_name = local.rg_name
  acr_login_server    = module.acr.login_server
  acr_username        = module.service_account.client_id
  secrets = {
    "acr-sp-secret" = module.service_account.client_secret
    "db-password"   = random_password.sql_admin.result # need to replace with non admin user
  }
  acr_secret_name           = "acr-sp-secret"
  container_name            = "rest-api"
  port                      = local.port
  cpu                       = 0.5
  memory                    = "1Gi"
  subnet_id                 = module.network.subnet_ids["app"]
  image                     = "varonishaacr.azurecr.io/restaurant-app:14" # To release a new version, change this
  allow_insecure_connection = true
  client_certificate_mode   = "ignore"
  external_enabled          = true
  env = {
    DB_SERVER = {
      value = module.azure_sql.server_fqdn
    }
    DB_NAME = {
      value = module.azure_sql.database_name
    }
    DB_USERNAME = {
      value = local.sql_admin_user
    }
    DB_PASSWORD = {
      secret_name = "db-password"
    }
    PORT = {
      value = local.port
    }
    HOST = {
      value = "0.0.0.0"
    }
  }

  liveness_probe = {
    path      = "/healthz"
    port      = local.port
    transport = "HTTP"
  }

  readiness_probe = {
    path      = "/healthz"
    port      = local.port
    transport = "HTTP"
  }
}

module "pdns_container_app" {
  source              = "./modules/private_dns"
  pdns_name           = module.container_app.default_domain
  virtual_network_id  = module.network.vnet_id
  resource_group_name = local.rg_name
  registration_enabled = false
  # Using https://learn.microsoft.com/en-us/azure/container-apps/waf-app-gateway?tabs=default-domain#retrieve-your-container-apps-domain
  # to connect the appgateway to the private app subnet
  private_dns_a_records = {
    "*" = {
      records = [module.container_app.static_ip]
    }
    "@" = {
      records = [module.container_app.static_ip]
    }
  }
}

#################
# Create related app gateway

resource "azurerm_public_ip" "pip" {
  name                = "rest"
  location            = local.location
  resource_group_name = local.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "rest"
}

module "app_gw" {
  source                  = "./modules/app_gw"
  app_gw_name             = "rest-gw"
  location                = local.location
  azure_key_id            = module.kv_sql.key_vault_id
  resource_group_name     = local.rg_name
  sku_name                = "WAF_v2"
  capacity                = 1
  azurerm_public_fqdn     = azurerm_public_ip.pip.fqdn
  subnet_id               = module.network.subnet_ids["appgw"]
  logs_storage_account_id = module.logs_storage.storage_account_id
  app_subnet_id           = module.network.subnet_ids["app"]
  app_static_ip           = module.container_app.static_ip
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
    api = { name = "api", fqdns = [module.container_app.fqdn] }
  }

  backend_http_settings = {
    api = {
      name                                = "api"
      port                                = 80
      protocol                            = "Http"
      cookie_based_affinity               = "Disabled"
      request_timeout                     = 30
      probe_name                          = "api-healthz"
      pick_host_name_from_backend_address = true
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
  health_probes = [
    {
      name                = "api-healthz"
      protocol            = "Http"
      path                = "/healthz"
      interval            = 15 # probe every 15s
      timeout             = 5  # wait up to 5s for a reply
      unhealthy_threshold = 2  # mark down after 2 failures
      host                = module.container_app.fqdn
    }
  ]
}
