# Core infrastructure
resource_group_name = "rg-varonis"
location            = "West Europe"

# Optional common tags applied to every resource
# (add whatever your organisation uses)
tags = {
  environment = "dev"
  owner       = "oren"
}

# # SQL Server configuration
# sql_server_name        = "varonis-sql-srv"      # must be globally unique
# administrator_login    = "sqladmin"
# administrator_password = "P@ssw0rd!ChangeMe" # <— store securely (e.g. TF_VAR_*, Vault)
# database_name          = "varonis_db"

# # Performance tier (see az sql db list-editions)
# sku_name = "GP_S_Gen5_2"   # General‑Purpose, Gen5, 2 vCores

# # (Optional) firewall rules — remove block if you don’t need any
# firewall_rules = {
#   office = {
#     start_ip = "1.2.3.4"
#     end_ip   = "1.2.3.4"
#   }
#   all_azure_services = {
#     start_ip = "0.0.0.0"
#     end_ip   = "0.0.0.0"
#   }
# }
