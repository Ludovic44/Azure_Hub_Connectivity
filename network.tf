# ======================== NETWORK ========================
# Resource group for network ressources used by the application
resource "azurerm_resource_group" "app_network" {
  name     = local.app_network_resource_group_name
  location = var.location
  tags     = local.tags
}

# ------------------------ FRC VNET------------------------
resource "azurerm_virtual_network" "app_frc" {
  name                = local.app_vnet_frc_name
  location            = var.location
  resource_group_name = azurerm_resource_group.app_network.name
  address_space       = var.app_vnet_frc_address_space
  tags                = local.tags
}

resource "azurerm_subnet" "app_subnets_frc" {
  for_each = var.app_subnets_frc != null ? var.app_subnets_frc : {}

  name                 = each.key
  resource_group_name  = azurerm_resource_group.app_network.name
  virtual_network_name = azurerm_virtual_network.app_frc.name
  address_prefixes     = each.value.address_prefixes

  # delegation
  dynamic "delegation" {
    for_each = each.value.service_delegation == true ? toset([1]) : []

    content {
      name = each.value.delegations.name
      service_delegation {
        name    = each.value.delegations.service_delegation.name
        actions = each.value.delegations.service_delegation.actions
      }
    }
  }
}


# ======================== NETWORK SECURITY GROUP ========================
# Network security groups to link to subnets
# ------------------------ NSG ------------------------
resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_group
  name     = each.value.name
  location = var.location
  # resource_group_name = each.value.resource_group
  resource_group_name = local.app_network_resource_group_name
  tags                = local.tags

  dynamic "security_rule" {
    for_each = each.value.security_rule
    content {
      name                       = security_rule.value.name
      description                = lookup(security_rule.value, "description", null)
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = lookup(security_rule.value, "source_port_range", "*")
      destination_port_range     = lookup(security_rule.value, "destination_port_range", "*")
      source_address_prefix      = lookup(security_rule.value, "source_address_prefix", "*")
      destination_address_prefix = lookup(security_rule.value, "destination_address_prefix", "*")
    }
  }

  depends_on = [
    azurerm_resource_group.app_network
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each = { for a in var.subnet_nsg_association : a.name => a }

  subnet_id                 = azurerm_subnet.app_subnets_frc[each.value.name].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group].id

  depends_on = [
    azurerm_subnet.app_subnets_frc,
    azurerm_network_security_group.nsg
  ]
}