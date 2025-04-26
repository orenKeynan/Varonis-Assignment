variable "app_gw_name" {
  description = "Application Gateway Name"
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing RG."
  type        = string
}

variable "azurerm_public_fqdn" {
  description = "azure public fqdn"
  type        = string
}

variable "azure_key_id" {
  description = "ID of Azure Key Vault"
  type        = string
}

variable "sku_name" {
  description = "App GW SKU."
  type        = string
  #default = "WAF_v2"
}
variable "capacity" {
  description = "Instance count."
  type        = number
  default     = 1
}
variable "subnet_id" {
  description = "Subnet for App GW."
  type        = string
}

variable "gw_ipcfg_name" {
  description = "Name of the Gateway-IP-Config block."
  type        = string
  default     = "gw-ipcfg"
}

variable "frontend_ports" {
  description = "Map of frontend-port objects."
  type = map(object({
    name = string
    port = number
  }))
}

variable "frontend_ip_configs" {
  description = "Public and/or private front-end IP configurations."
  type = map(object({
    name               = string
    public_ip_id       = optional(string) # supply one of public_ip_id OR subnet_id
    subnet_id          = optional(string)
    private_ip_address = optional(string)
  }))
}

variable "ssl_certs" {
  description = "Certificates (map for easy SNI future-proofing)."
  type = map(object({
    name         = string
    pfx_path     = string
    pfx_password = string
  }))
  default = {}
}

variable "backend_pools" {
  description = "Backend pools keyed by arbitrary names."
  type = map(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "HTTP settings per pool."
  type = map(object({
    name                  = string
    port                  = number
    protocol              = string # Http or Https
    cookie_based_affinity = string # Enabled / Disabled
    request_timeout       = number
    probe_name            = optional(string, null)
  }))
}

variable "http_listeners" {
  description = "Listener definitions."
  type = map(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string # Http / Https
    ssl_certificate_name           = optional(string)
    host_name                      = optional(string)
  }))
}

variable "request_routing_rules" {
  description = "Routing rules."
  type = map(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    priority                   = optional(number)
  }))
}

variable "enable_waf" {
  description = "Turn WAF on/off."
  type        = bool
  default     = true
}

variable "waf_firewall_mode" {
  description = "Prevention or Detection."
  type        = string
  default     = "Prevention"
}

variable "waf_rule_set_type" {
  description = "Rule set family."
  type        = string
  default     = "OWASP"
}

variable "waf_rule_set_version" {
  description = "OWASP CRS version."
  type        = string
  default     = "3.2"
}

variable "user_assigned_identity_name" {
  description = "Identity name to access the cert"
  type = string
  default = "container-iden"
}

variable "retention_in_days" {
  description = "Retention of logs in days"
  type        = number
  default     = 30
}

variable "logs_storage_account_id" {
  description = "Storage account for diagnostics."
  type        = string
}

variable "app_subnet_id" {
  description = "The private subnet of the application"
  type = string
}

variable "app_static_ip" {
  description = "The static ip of the Container app"
  type = string
}

variable "health_probes" {
  description = "List of health probes to configure on the Application Gateway"
  type = list(object({
    name                                    = string
    protocol                                = string                        # "Http" or "Https"
    host                                    = optional(string)              # e.g. "my-app.internal"
    path                                    = optional(string)              # e.g. "/healthz"
    interval                                = optional(number)              # probe interval in seconds
    timeout                                 = optional(number)              # probe timeout in seconds
    unhealthy_threshold                     = optional(number)              # how many failures before marking unhealthy
    pick_host_name_from_backend_http_settings = optional(bool)              # whether to reuse host from http-settings
    match = optional(object({                                       # what status codes count as healthy
      status_code = list(string)
    }))
  }))
  default = []
}
