# Azure SQL Module

This sub‑module creates (or re‑uses) an Azure Resource Group, a SQL Server, a single
Database, and optional firewall rules.

```hcl
module "azure_sql" {
  source = "./modules/azure_sql"

  resource_group_name    = "rg-varonis"
  location               = "West Europe"
  sql_server_name        = "varonis-sql-srv"
  administrator_login    = "sqladmin"
  administrator_password = var.admin_password
  database_name          = "varonis_db"
  sku_name               = "GP_S_Gen5_2"

  firewall_rules = {
    office = {
      start_ip = "1.2.3.4"
      end_ip   = "1.2.3.4"
    }
  }
}
```

*All resources are tagged and `prevent_destroy` is set on the database for safety.*
