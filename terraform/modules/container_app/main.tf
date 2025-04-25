resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.app_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}

resource "azurerm_container_app_environment" "env" {
  name                       = "${var.app_name}-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  internal_load_balancer_enabled = true
  infrastructure_subnet_id       = var.subnet_id
}

resource "azurerm_container_app" "app" {
  name                         = var.app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
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
  name                       = "diag-storage"
  target_resource_id         = azurerm_container_app.app.id
  storage_account_id         = var.logs_storage_account_id
  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.app.log_category_types
    content {
      category = enabled_log.value
    }
  }
}
