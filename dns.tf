# ======================== RESOURCE GROUP ========================
resource "azurerm_resource_group" "app_dns" {
  name     = local.app_dns_resource_group_name
  location = var.location
  tags     = local.tags
}

# ======================== PRIVATE DNS ZONE ========================
resource "azurerm_private_dns_zone" "app_dns_private_zones" {
  for_each = { for zone in var.app_dnsprivatezones : zone.zone_name => zone }

  name                = each.value.zone_name
  resource_group_name = azurerm_resource_group.app_dns.name
  tags                = local.tags
}


# ======================== PRIVATE DNS ZONE ASSOCIATION ========================
resource "azurerm_private_dns_zone_virtual_network_link" "priv_dns_zone_vnet_link" {
  for_each = { for zone in var.app_dnsprivatezones : zone.zone_name => zone if lookup(zone, "vnet_link", false) }

  name                  = "link_${replace(each.value.zone_name, ".", "-")}_to_${local.app_vnet_frc_name}"
  resource_group_name   = azurerm_resource_group.app_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.app_dns_private_zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.app_frc.id
  registration_enabled  = false
}

# ======================== DNS PRIVATE RESOLVER ========================
# resource "azurerm_private_dns_resolver" "dns_private_resolver" {
#   name                = local.app_dnsprivateresolver_name
#   resource_group_name = azurerm_resource_group.app_dns.name
#   location            = var.location
#   tags                = local.tags
# }


# ======================== DNS PRIVATE RESOLVER VNET LINK ========================
# resource "azurerm_private_dns_resolver_virtual_network_link" "dns_private_resolver_vnet_link" {
#   name                      = "link-${local.app_vnet_frc_name}"
#   resource_group_name       = azurerm_resource_group.app_dns.name
#   private_dns_resolver_id   = azurerm_private_dns_resolver.dns_private_resolver.id
#   virtual_network_id        = azurerm_virtual_network.app_vnet_frc.id
#   registration_enabled      = false
# }


# ======================== DNS PRIVATE RESOLVER RULE ========================
# resource "azurerm_private_dns_resolver_rule" "dns_private_resolver_rule" {
#   name                      = "rule-azure"
#   resource_group_name       = azurerm_resource_group.app_dns.name
#   private_dns_resolver_id   = azurerm_private_dns_resolver.dns_private_resolver.id
#   domain_name               = "azure.com"
#   forwarder_ip_addresses    = ["<forwarder_ip_address>"]
#   tags                      = local.tags
# }


# ======================== DNS PRIVATE RESOLVER RULE ASSOCIATION ========================
# resource "azurerm_private_dns_resolver_rule_association" "dns_private_resolver_rule_association" {
#   name                      = "assoc-azure"
#   resource_group_name       = azurerm_resource_group.app_dns.name
#   private_dns_resolver_rule_id = azurerm_private_dns_resolver_rule.dns_private_resolver_rule.id
#   private_dns_resolver_id   = azurerm_private_dns_resolver.dns_private_resolver.id
# } 