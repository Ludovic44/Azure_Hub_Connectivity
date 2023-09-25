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

  # subnet {
  #   name           = var.subnet-name_firewall
  #   address_prefix = [var.subnet-iprange_firewall]
  #   security_group = azurerm_network_security_group.firewall.id
  # }

  # subnet {
  #   name           = var.subnet-name_bastion
  #   address_prefix = [var.subnet-iprange_bastion]
  #   security_group = azurerm_network_security_group.bastion.id
  # }

  # subnet {
  #   name           = var.subnet-name_apim
  #   address_prefix = [var.subnet-iprange_apim]
  #   security_group = azurerm_network_security_group.apim.id
  # }

  # subnet {
  #   name           = var.subnet-name_natgateway
  #   address_prefix = [var.subnet-iprange_natgateway]
  #   security_group = azurerm_network_security_group.natgateway.id
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

# Network Security Group
resource "azurerm_network_security_group" "vpngateway" {
  provider            = azurerm.subprod001  
  name                = var.nsg_name_vpngateway
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Subnet
resource "azurerm_subnet" "vpngateway" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_vpngateway
  resource_group_name  = azurerm_resource_group.vpngateway.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_vpngateway]
}

# Local network gateway
resource "azurerm_local_network_gateway" "dc44" {
  provider            = azurerm.subprod001 
  name                = var.local-network-gateway_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name
  gateway_address     = var.local-network-gateway_ip-address
  address_space       = [var.local-network-gateway_address-space_dc44]
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

#   vpn_client_configuration {
#     address_space = ["10.2.0.0/24"]

#     root_certificate {
#       name = "DigiCert-Federated-ID-Root-CA"

#       public_cert_data = <<EOF
# MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
# MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
# d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
# Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
# BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
# Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
# QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
# zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
# GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
# GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
# Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
# DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
# HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
# jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
# 9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
# QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
# uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
# WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
# M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
# EOF

#     }

#     revoked_certificate {
#       name       = "Verizon-Global-Root-CA"
#       thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
#     }
#   }

  tags = merge(var.tags, {
    application = "vpngateway"
  })
}

# Local network gateway
resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  provider            = azurerm.subprod001
  name                = var.vpngateway_connection_name
  location            = azurerm_resource_group.vpngateway.location
  resource_group_name = azurerm_resource_group.vpngateway.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network.hub.id
  local_network_gateway_id   = azurerm_local_network_gateway.dc44.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
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

# Network Security Group
resource "azurerm_network_security_group" "firewall" {
  provider            = azurerm.subprod001  
  name                = var.nsg_name_firewall
  location            = azurerm_resource_group.firewall.location
  resource_group_name = azurerm_resource_group.firewall.name

  tags = merge(var.tags, {
    application = "firewall"
  })
}

# Subnet
resource "azurerm_subnet" "firewall" {
  provider            = azurerm.subprod001
  name                 = var.subnet_name_firewall
  resource_group_name  = azurerm_resource_group.firewall.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet-iprange_firewall]
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

# Network Security Group
resource "azurerm_network_security_group" "bastion" {
  provider            = azurerm.subprod001  
  name                = var.nsg_name_bastion
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name

  tags = merge(var.tags, {
    application = "bastion"
  })
}

# Subnet
resource "azurerm_subnet" "bastion" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_bastion
  resource_group_name  = azurerm_resource_group.bastion.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_bastion]
}

# Bastion


# =========================================================
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

# Network Security Group
resource "azurerm_network_security_group" "apim" {
  provider            = azurerm.subprod001  
  name                = var.nsg_name_apim
  location            = azurerm_resource_group.apim.location
  resource_group_name = azurerm_resource_group.apim.name

  tags = merge(var.tags, {
    application = "apim"
  })
}

# Subnet
resource "azurerm_subnet" "apim" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_bastion
  resource_group_name  = azurerm_resource_group.apim.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_apim]
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

# Network Security Group
resource "azurerm_network_security_group" "natgateway" {
  provider            = azurerm.subprod001  
  name                = var.nsg_name_natgateway
  location            = azurerm_resource_group.natgateway.location
  resource_group_name = azurerm_resource_group.natgateway.name
  tags = merge(var.tags, {
    application = "natgateway"
  })
}

# Subnet
resource "azurerm_subnet" "natgateway" {
  provider            = azurerm.subprod001  
  name                 = var.subnet_name_bastion
  resource_group_name  = azurerm_resource_group.natgateway.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.subnet_iprange_natgateway]
}

# NAT gateway
