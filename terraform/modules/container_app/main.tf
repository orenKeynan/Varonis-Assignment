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
  dynamic "secret" {
    for_each = var.secrets
    content {
      name  = secret.key
      value = secret.value
    }
  }


  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = var.acr_secret_name
  }
  ingress {
    target_port                = var.port
    allow_insecure_connections = var.allow_insecure_connection
    external_enabled           = var.external_enabled
    client_certificate_mode    = var.client_certificate_mode
    traffic_weight {
      percentage      = 100
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
          name        = env.key
          value       = try(env.value.value, null)
          secret_name = try(env.value.secret_name, null)
        }
      }
      liveness_probe {
        path      = var.liveness_probe.path
        port      = var.port
        transport = var.liveness_probe.transport
      }
      readiness_probe {
        path      = var.liveness_probe.path
        port      = var.port
        transport = var.liveness_probe.transport
      }
    }
  }
  identity {
    type = "SystemAssigned"
  }
}
