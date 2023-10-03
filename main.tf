# =========================================================
# Global

# Resource group
resource "azurerm_resource_group" "hub" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_common
  location        = var.location

  tags = var.tags
}


# =========================================================
# VIRTUAL NETWORK and SUBNET

resource "azurerm_virtual_network" "hub" {
  provider            = azurerm.subprod001
  name                = var.vnet_name_hub
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  address_space       = [var.vnet_iprange_hub]
#  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  # subnet {
  #   name           = var.subnet-name_vpngateway
  #   address_prefix = [var.subnet-iprange_vpngateway]
  #   security_group = azurerm_network_security_group.vpngateway.id
  # }

  tags = var.tags
}


# =========================================================
# VIRTUAL NETWORK GATEWAY
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway

# Resource group
resource "azurerm_resource_group" "vpngateway" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_vpngateway
  location        = var.location

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Public IP address
resource "azurerm_public_ip" "vpngateway" {
  provider            = azurerm.subprod001
  name                = var.public-ip_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name

  allocation_method = "Dynamic"

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Subnet
resource "azurerm_subnet" "vpngateway" {
  provider             = azurerm.subprod001  
  name                 = var.subnet_name_vpngateway
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_vpngateway]
}

# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "prod" {
  provider            = azurerm.subprod001
  name                = var.vpngateway_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vpngateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpngateway.id
  }

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Local network gateway
resource "azurerm_local_network_gateway" "dc44" {
  provider            = azurerm.subprod001 
  name                = var.local-network-gateway_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name
  gateway_address     = var.local-network-gateway_ip-address
  address_space       = [var.local-network-gateway_address-space_dc44]

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Site-to-site connection
resource "azurerm_virtual_network_gateway_connection" "dc44" {
  provider            = azurerm.subprod001
  name                = var.dc44-to-vpngateway_connection_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.prod.id
  local_network_gateway_id   = azurerm_local_network_gateway.dc44.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}


# =========================================================
# FIREWALL

# Resource group
resource "azurerm_resource_group" "firewall" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_firewall
  location        = var.location

  tags = merge(var.tags, {
    application = "firewall"
  })
}

# # Network Security Group
# resource "azurerm_network_security_group" "firewall" {
#   provider            = azurerm.subprod001  
#   name                = var.nsg_name_firewall
#   location            = azurerm_resource_group.firewall.location
#   resource_group_name = azurerm_resource_group.firewall.name

#   tags = merge(var.tags, {
#     application = "firewall"
#   })
# }

# Subnet
resource "azurerm_subnet" "firewall" {
  provider            = azurerm.subprod001
  name                 = var.subnet_name_firewall
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet-iprange_firewall]
}

# Network Security Group
resource "azurerm_network_security_group" "firewall" {
  provider            = azurerm.subprod001
  name                = var.nsg_name_firewall
  location            = azurerm_resource_group.firewall.location
  resource_group_name = azurerm_resource_group.firewall.name

  security_rule {
    name                       = "nsgsr-allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    application = "firewall"
  })
}

# Association from NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "firewall" {
  provider                  = azurerm.subprod001
  subnet_id                 = azurerm_subnet.firewall.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}

# Firewall


# =========================================================
# BASTION

# Resource group
resource "azurerm_resource_group" "bastion" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_bastion
  location        = var.location

  tags = merge(var.tags, {
    application = "bastion"
  })
}

# Subnet
resource "azurerm_subnet" "bastion" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_bastion
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_bastion]
}

# Network Security Group
# https://wmatthyssen.com/2022/08/11/azure-bastion-set-azure-bastion-nsg-inbound-security-rules-on-the-target-vm-subnet-with-azure-powershell/
resource "azurerm_network_security_group" "bastion" {
  provider            = azurerm.subprod001
  name                = var.nsg_name_bastion
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name

  security_rule {
    name                       = "nsgsr-allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    application = "bastion"
  })
}

# # Association from NSG to Subnet
# resource "azurerm_subnet_network_security_group_association" "bastion" {
#   provider                  = azurerm.subprod001
#   subnet_id                 = azurerm_subnet.bastion.id
#   network_security_group_id = azurerm_network_security_group.bastion.id
# }

# Bastion


# # =========================================================
# APIM

# Resource group
resource "azurerm_resource_group" "apim" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_apim
  location        = var.location

  tags = merge(var.tags, {
    application = "apim"
  })
}

# Subnet
resource "azurerm_subnet" "apim" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_apim
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_apim]
}

# Network Security Group
resource "azurerm_network_security_group" "apim" {
  provider            = azurerm.subprod001
  name                = var.nsg_name_apim
  location            = azurerm_resource_group.apim.location
  resource_group_name = azurerm_resource_group.apim.name

  security_rule {
    name                       = "nsgsr-allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    application = "apim"
  })
}

# Association from NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "apim" {
  provider                  = azurerm.subprod001
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.apim.id
}

# APIM


# =========================================================
# NAT Gateway

# Resource group
resource "azurerm_resource_group" "natgateway" {
  provider        = azurerm.subprod001 
  name            = var.resource-group_name_natgateway
  location        = var.location

  tags = merge(var.tags, {
    application = "natgateway"
  })
}

# Subnet
resource "azurerm_subnet" "natgateway" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_natgateway
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_natgateway]
}

# Network Security Group
resource "azurerm_network_security_group" "natgateway" {
  provider            = azurerm.subprod001
  name                = var.nsg_name_natgateway
  location            = azurerm_resource_group.natgateway.location
  resource_group_name = azurerm_resource_group.natgateway.name

  security_rule {
    name                       = "nsgsr-allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(var.tags, {
    application = "natgateway"
  })
}

# Association from NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "natgateway" {
  provider                  = azurerm.subprod001
  subnet_id                 = azurerm_subnet.natgateway.id
  network_security_group_id = azurerm_network_security_group.natgateway.id
}

# NAT gateway
