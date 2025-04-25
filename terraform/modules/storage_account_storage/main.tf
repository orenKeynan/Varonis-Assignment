resource "azurerm_storage_account" "this" {
  # Use a fixed name passed in by the caller
  name                     = var.sa_name  
  resource_group_name      = var.resource_group_name  
  location                 = var.location  
  account_kind             = "StorageV2"

  # Performance & replication settings  
  account_tier             = var.account_tier  
  account_replication_type = var.account_replication_type  

  # Security defaults
  min_tls_version                   = "TLS1_2"  
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled  

  # Network lockdown so only your VNet / Azure services can write logs  
  network_rules {
    default_action             = "Deny"  
    bypass                     = ["AzureServices"]  
    virtual_network_subnet_ids = var.network_subnet_ids
  }
}
