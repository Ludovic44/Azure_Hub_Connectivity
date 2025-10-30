# ======================== RESOURCE GROUP ========================
resource "azurerm_resource_group" "app_bastion" {
  name     = local.app_bastion_resource_group_name
  location = var.location
  tags     = local.tags
}

# ======================== PUBLIC IP ========================
# resource "azurerm_public_ip" "bastion" {
#   name                = local.pip_bastion_name
#   resource_group_name = azurerm_resource_group.app_bastion.name
#   location            = azurerm_resource_group.app_bastion.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   tags                = local.tags
# }


# # ======================== BASTION ========================
# # Create Azure Bastion Host
# resource "azurerm_bastion_host" "bastion" {
#   name                = local.app_bastion_name
#   location            = azurerm_resource_group.bastion.location
#   resource_group_name = azurerm_resource_group.bastion.name
#   sku                 = "Basic"

#   copy_paste_enabled     = true
#   file_copy_enabled      = false # `file_copy_enabled` is only supported when `sku` is `Standard` or `Premium`
#   shareable_link_enabled = false # `shareable_link_enabled` is only supported when `sku` is `Standard` or `Premium`
#   tunneling_enabled      = false # `tunneling_enabled` is only supported when `sku` is `Standard` or `Premium`

#   ip_configuration {
#     name                 = "bastion_ip_configuration"
#     subnet_id            = azurerm_subnet.subnet["AzureBastionSubnet"].id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }
# }