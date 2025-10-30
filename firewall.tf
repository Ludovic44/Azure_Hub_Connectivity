resource "azurerm_resource_group" "app_firewall" {
  name     = local.app_firewall_resource_group_name
  location = var.location
  tags     = local.tags
}

# resource "azurerm_firewall" "app_firewall" {
#   name                = local.app_firewall_name
#   location            = azurerm_resource_group.app_firewall.location
#   resource_group_name = azurerm_resource_group.app_firewall.name
#   sku_name            = "AZFW_VNet"
#   sku_tier            = "Basic"
#   threat_intel_mode   = "Alert"

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.subnet["AzureFirewallSubnet"].id
#     public_ip_address_id = azurerm_public_ip.firewall.id
#   }
#   tags = local.tags
# }