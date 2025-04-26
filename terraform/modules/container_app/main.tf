resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.app_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}

resource "azurerm_container_app_environment" "env" {
  name                           = "${var.app_name}-env"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.logs.id
  internal_load_balancer_enabled = true
  infrastructure_subnet_id       = var.subnet_id
}

resource "azurerm_container_app" "app" {
  name                         = var.app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  secret {
    name  = var.acr_secret_name
    value = var.acr_secret_value
  }

  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = var.acr_secret_name
  }
  ingress {
      target_port      = var.port
      external_enabled = false
      traffic_weight {
        percentage = 100
        latest_revision = true 
      }
  }
  template {
    min_replicas                     = var.min_replicas
    max_replicas                     = var.max_replicas
    termination_grace_period_seconds = var.termination_grace_period_seconds
    container {
      name   = var.container_name
      image  = var.image
      cpu    = var.cpu
      memory = var.memory
      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_monitor_diagnostic_categories" "app" {
  resource_id = azurerm_container_app.app.id
}

resource "azurerm_monitor_diagnostic_setting" "to_sa" {
  name               = "diag-storage"
  target_resource_id = azurerm_container_app.app.id
  storage_account_id = var.logs_storage_account_id
  enabled_log {
      category = "allLogs"
  }
}
