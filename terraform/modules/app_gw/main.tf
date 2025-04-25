resource "azurerm_public_ip" "pip" {
  name                = var.app_gw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.app_gw_name
}

# self-signed cert whose CN = FQDN of the public IP
resource "azurerm_key_vault_certificate" "tls" {
  name         = "${var.app_gw_name}-ss-cert"
  key_vault_id = var.azure_key_id # azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }
    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }
    secret_properties {
      content_type = "application/x-pkcs12"
    }
    x509_certificate_properties {
      subject                        = "CN=${azurerm_public_ip.pip.fqdn}"
      validity_in_months             = 12
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
    }
    lifetime_action {
      action {
        action_type = "AutoRenew"
      }
      trigger {
        days_before_expiry = 365 # 1 year
      }
    }
  }
}

resource "azurerm_application_gateway" "this" {
  name                = var.app_gw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = var.sku_name
    tier     = var.sku_name
    capacity = var.capacity
  }
  gateway_ip_configuration {
    name      = var.gw_ipcfg_name
    subnet_id = var.subnet_id
  }

  # Front-end ports
  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  # Front-end IP configurations (public or private)
  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configs
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = lookup(frontend_ip_configuration.value, "public_ip_id", null)
      subnet_id            = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address   = lookup(frontend_ip_configuration.value, "private_ip_address", null)
    }
  }

  # SSL certificates (multiple if you use SNI)
  dynamic "ssl_certificate" {
    for_each = var.ssl_certs
    content {
      name     = ssl_certificate.value.name
      data     = filebase64(ssl_certificate.value.pfx_path)
      password = ssl_certificate.value.pfx_password
    }
  }

  # Backend address pools
  dynamic "backend_address_pool" {
    for_each = var.backend_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  # Backend HTTP settings
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  # Listeners
  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      host_name                      = lookup(http_listener.value, "host_name", null)
    }
  }

  # Routing rules
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      priority                   = lookup(request_routing_rule.value, "priority", null)
    }
  }

  # Optional WAF block (rendered only when enabled)
  dynamic "waf_configuration" {
    for_each = var.enable_waf ? [1] : []
    content {
      enabled          = var.enable_waf
      firewall_mode    = var.waf_firewall_mode
      rule_set_type    = var.waf_rule_set_type
      rule_set_version = var.waf_rule_set_version
    }
  }
}
