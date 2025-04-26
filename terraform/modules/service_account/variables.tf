variable "name" {
  description = "Display name for the service principal"
  type        = string
}

variable "acr_id" {
  description = "Resource ID of the existing Azure Container Registry"
  type        = string
}

variable "secret_length" {
  description = "Length of the generated client secret"
  type        = number
  default     = 16
}

variable "secret_expire_hours" {
  description = "Secret validity period in hours"
  type        = number
  default     = 720
}
