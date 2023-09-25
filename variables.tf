# =========================================================
# Global

variable "tenant_id" {
    type        = string
    default     = "75046d40-2d4b-40d8-acaf-696b9e5679f8"
    description = "Tenant ID"
}

variable "location" {
    type        = string
    default     = "France Central"
    description = "Location for all the resources"
}

variable "environment" {
    type        = string
    default     = "dev"
    description = "Environment of deployed resource"
}

variable "tags" {
    type        = map(string)
    default     = {
        distribution = "hub"
        environment = "production"
    }
    description = "Tags to apply to resources groupe and resources"
}

variable "resource-group_name_common" {
    type        = string
    default     = "rg-common-hub-prod-002"
    description = "Resource group name"
}


# =========================================================
# VIRTUAL NETWORK

variable "vnet_name_hub" {
    type        = string
    default     = "vnet-hub-prod-1010-001"
    description = "Hub VNet name"
}

variable "vnet_iprange_hub" {
    type        = string
    default     = "10.10.0.0/16"
    description = "Hub VNet IP range"
}


# =========================================================
# VIRTUAL NETWORK GATEWAY

# Resource group
variable "resource-group_name_vpngateway" {
    type        = string
    default     = "rg-vpngateway-hub-prod-001"
    description = "Virtual Network Gateway resource group name"
}

# Public IP address
variable "public-ip_name" {
    type        = string
    default     = "pip-vpngateway-prod-001"
    description = "Public IP address name"
}

# Network Security Group
variable "nsg_name_vpngateway" {
    type        = string
    default     = "nsg-vpngateway-hub-prod-001"
    description = "VPN Gateway network security group name"
}

# Subnet
variable "subnet_name_vpngateway" {
    type        = string
    default     = "GatewaySubnet"
    description = "VPN Gateway subnet name"
}

variable "subnet_iprange_vpngateway" {
    type        = string
    default     = "10.10.1.0/27"
    description = "VPN Gateway subnet IP range"
}

# Local network gateway
variable "local-network-gateway_name" {
    type        = string
    default     = "lgw-dc44-prod"
    description = "Local network gateway name"
}

variable "local-network-gateway_ip-address" {
    type        = string
    default     = "168.62.225.23"
    description = "Local network gateway IP address for DC44 site"
}

variable "local-network-gateway_address-space_dc44" {
    type        = string
    default     = "192.168.10.0/24"
    description = "Local network gateway address space for DC44 site"
}

# VPN Gateway
variable "vpngateway_name" {
    type        = string
    default     = "vpng-prod-001"
    description = "VPN Gateway name"
}

# Sitte-to-site connection
variable "vpngateway_connection_name" {
    type        = string
    default     = "cn-lgw-dc44-prod-001-to-vpng-prod-001"
    description = "Site-ti-site connection name"
}


# =========================================================
# FIREWALL

# Resource group
variable "resource-group_name_firewall" {
    type        = string
    default     = "rg-firewall-hub-prod-001"
    description = "Firewall resource group name"
}

# Network Security Group
variable "nsg_name_firewall" {
    type        = string
    default     = "nsg-firewall-hub-prod-001"
    description = "Firewall network security group name"
}

# Subnet
variable "subnet_name_firewall" {
    type        = string
    default     = "snet-firewall-hub-prod-001"
    description = "Firewall subnet name"
}

variable "subnet-iprange_firewall" {
    type        = string
    default     = "10.10.2.0/26"
    description = "Firewall subnet IP range"
}

# Firewall
variable "firewall_name" {
    type        = string
    default     = "afw-prod-001"
    description = "Firewall name"
}


# =========================================================
# BASTION

# Resource group
variable "resource-group_name_bastion" {
    type        = string
    default     = "rg-bastion-hub-prod-001"
    description = "Bastion resource group name"
}

# Network Security Group
variable "nsg_name_bastion" {
    type        = string
    default     = "nsg-bastion-hub-prod-001"
    description = "Bastion network security group name"
}

# Subnet
variable "subnet_name_bastion" {
    type        = string
    default     = "AzureBastionSubnet"
    description = "Bastion subnet name"
}

variable "subnet_iprange_bastion" {
    type        = string
    default     = "10.10.3.0/26"
    description = "Bastion subnet IP range"
}

# Bastion
variable "bastion_name" {
    type        = string
    default     = "bas-prod-001"
    description = "Bastion name"
}


# =========================================================
# APIM

# Resource group
variable "resource-group_name_apim" {
    type        = string
    default     = "rg-apim-hub-prod-001"
    description = "APIM resource group name"
}

# Network Security Group
variable "nsg_name_apim" {
    type        = string
    default     = "nsg-apim-hub-prod-001"
    description = "APIM network security group name"
}

# Subnet
variable "subnet_name_apim" {
    type        = string
    default     = "snet-apim-hub-prod-001"
    description = "APIM subnet name"
}

variable "subnet_iprange_apim" {
    type        = string
    default     = "10.10.4.0/26"
    description = "APIM subnet IP range"
}

# APIM
variable "apim_name" {
    type        = string
    default     = "apim-prod-001"
    description = "APIM name"
}


# =========================================================
# NAT GATEWAY

# Resource group
variable "resource-group_name_natgateway" {
    type        = string
    default     = "rg-natgateway-hub-prod-001"
    description = "APIM resource group name"
}

# Network Security Group
variable "nsg_name_natgateway" {
    type        = string
    default     = "nsg-natgateway-hub-prod-001"
    description = "NAT Gateway network security group name"
}

# Subnet
variable "subnet_name_natgateway" {
    type        = string
    default     = "snet-natgateway-hub-prod-001"
    description = "NAT Gateway subnet name"
}

variable "subnet_iprange_natgateway" {
    type        = string
    default     = "10.10.5.0/24"
    description = "NAT Gateway subnet IP range"
}

# NAT Gateway
variable "natgateway_name" {
    type        = string
    default     = "ng-prod-001"
    description = "NAT Gateway name"
}
