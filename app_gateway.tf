resource "azurerm_resource_group" "app_appgateway" {
  name     = local.app_appgateway_resource_group_name
  location = var.location
  tags     = local.tags
}