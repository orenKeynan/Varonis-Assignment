variable "name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region for the Resource Group."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Resource Group."
  type        = map(string)
  default     = {}
}
