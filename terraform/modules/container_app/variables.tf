variable "app_name" {
    description = "App name"
    type = string
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
    type = string
}

variable "cpu" {
    description = "vCPU per replica." 
    type = number
    default = 0.25
}

variable "memory" {
    description = "GiB per replica."
    type = number
    default = 0.5
}

variable "subnet_id" {
    description = "Subnet for container env."
    type = string
}

variable "env" {
    description = "ENV VARS to pass to the app"
    type = map(string)
    default = {}
}

variable "container_name" {
    description = "Container's name"
    type = string
}

variable "logs_storage_account_id" {
    description = "Storage account for diagnostics."
    type = string
}

variable "sku" {
    description = "SKU of container app logs analytics"
    type = string
    default = "PerGB2018"
}

variable "retention_in_days" {
    description = "Retention of logs in days"
    type = number
    default = 5
}
