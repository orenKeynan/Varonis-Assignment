variable "app_name" {
  description = "App name"
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

variable "image" {
  description = "Docker image URI."
  type        = string
}

variable "cpu" {
  description = "vCPU per replica."
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "GiB per replica."
  type        = string
  default     = "0.5Gi"
}

variable "subnet_id" {
  description = "Subnet for container env."
  type        = string
}

variable "env" {
  description = "ENV VARS to pass to the app"
  type        = map(string)
  default     = {}
}

variable "container_name" {
  description = "Container's name"
  type        = string
}

variable "sku" {
  description = "SKU of container app logs analytics"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention of logs in days"
  type        = number
  default     = 30
}

variable "min_replicas" {
  description = "minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "max number of replicas"
  type        = number
  default     = 3
}

variable "termination_grace_period_seconds" {
  description = "time for pod to finish it's proecessing before forcing it"
  type        = number
  default     = 60
}

variable "acr_secret_name" {
  description = "ACR Secret value name"
  type        = string
}

variable "acr_secret_value" {
  description = "ACR Secret value value"
  type        = string
}

variable "acr_login_server" {
  description = "ACR Login Server"
  type        = string
}

variable "acr_username" {
  description = "ACR Username"
  type        = string
}

variable "port" {
  description = "application port"
  type = number
}

variable "allow_insecure_connection" {
  type = bool
  default = false
}

variable "client_certificate_mode" {
  type = string
  default = "ignore"
}

variable "external_enabled" {
  type = bool
  default = true
}

variable "liveness_probe" {
  description = "Configuration for the container liveness probe"
  type = object({
    path                    = string
    transport               = string
    port                    = number
  })
}

variable "readiness_probe" {
  description = "Configuration for the container readiness probe"
  type = object({
    path                    = string
    transport               = string
    port                    = number
  })
}
