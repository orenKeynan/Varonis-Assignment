/*** Generic, name-agnostic outputs ***/

# VNet information
output "vnet_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_address_space" {
  description = "Address prefixes of the VNet."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Map of <subnet_name> => <subnet_id> for all subnets."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

# Optional: expose full objects if callers want more than just IDs
output "subnets" {
  description = "Map of <subnet_name> => object(id,cidr)."
  value = {
    for name, subnet in azurerm_subnet.this :
    name => {
      id   = subnet.id
      cidr = subnet.address_prefixes[0]
    }
  }
}
