resource "azurerm_resource_group" "app_gateway" {
  name     = local.app_gateway_resource_group_name
  location = var.location
  tags     = local.tags
}