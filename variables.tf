# VARIABLES DECLARATION
# Name, Type, Description, Default value and metadata

# ======================== GLOBAL ========================
variable "environment" {
  type        = string
  description = "The environment in which all resources in this deployment should be created."
  default     = "development"
}

variable "env" {
  type        = string
  description = "The environment abbreviation in which all resources in this deployment should be created."
  default     = "dev"
  validation {
    condition     = contains(["sbx", "dev", "rct", "npd", "ppd", "prd", ], var.env)
    error_message = "'env' variable must be one of the following values: 'basb', 'qual', 'rect', 'pprd' or 'prod'"
  }
}

variable "tenant_id" {
  type        = string
  description = "The Tenant ID in which all resources in this deployment should be created."
  default     = ""
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID in which all resources groups in this deployment should be created."
  default     = ""
}

variable "client_id" {
  type        = string
  description = "The client ID use with provider AzureRM to deploy resources."
  default     = ""
}

# variable "secret_id" {
#   type        = string
#   sensitive   = true
#   description = "The secret of client ID use with provider AzureRM to deploy resources."
#   default     = ""
# }

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
  default     = "francecentral"
}

variable "loc" {
  type        = string
  description = "The Azure Region, on 3 characters, in which all resources in this example should be created."
  default     = "frc"
}

variable "application" {
  type        = string
  description = "The application in which all resources in this example should be created."
  default     = ""
}

variable "app" {
  type        = string
  description = "The abbreviation of the application in which all resources in this example should be created."
  default     = ""
}


# ======================== NETWORK ========================
# ------------------------  APP VNET ------------------------
variable "app_network_resource_group_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}

variable "app_vnet_frc_name" {
  type        = string
  description = "The name of the virtual network for Application spoke hosted in France central."
  default     = ""
}

variable "app_vnet_frc_address_space" {
  type        = list(string)
  description = "The IP address space of virtual network of West Europe region."
  default     = ["10.a.b.c/24"]
}

# ------------------------ SUBNETS ------------------------
variable "app_subnets_frc" {
  type = map(object(
    {
      address_prefixes = list(string) # (Required) The address prefixes to use for the subnet.
      # delegation
      service_delegation = bool
      delegations = optional(object(
        {
          name = string # (Required) A name for this delegation.
          service_delegation = object({
            name    = string                 # (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments` and `PaloAltoNetworks.Cloudngfw/firewalls`.
            actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
          })
        }
        )
      )

    }
  ))
  description = "Subnets list to create"
}


# ------------------------ NSG ------------------------
variable "network_security_group" {
  type = map(object({
    name = string
    # resource_group = string
    security_rule = map(object({
      name                       = string
      description                = optional(string)
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    }))
  }))
}

variable "subnet_nsg_association" {
  type = list(object({
    name                   = string
    network_security_group = string
  }))
}

# ======================== NVA VM ========================
variable "app_nva_vm_orchestration_size" {
  type        = string
  description = "The orchestration size for the NVA VM."
  default     = "Standard_B2ms"
}

# ======================== FIREWALL ========================
variable "app_firewall_resource_group_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}

variable "app_firewall_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}


# ======================== BASTION ========================
variable "app_bastion_resource_group_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}

variable "app_bastion_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}

variable "pip_bastion_name" {
  type        = string
  description = "The name of the public IP address for the Bastion host."
  default     = ""
}


# ======================== DNS ========================
variable "app_dns_resource_group_name" {
  type        = string
  description = "The name of the resource group in which all network resources will be created."
  default     = ""
}

variable "app_dnsprivateresolver_name" {
  type        = string
  description = "The name of the DNS private resolver."
  default     = ""
}

# variable "app_dnsprivatezones" {
#   type = map(object(
#     {
#       # delegation
#       vnet_link = bool
#     }
#   ))
#   description = "Private DNS zones to create"
# }

// Variable for private DNS zones
variable "app_dnsprivatezones" {
  description = "Settings for private DNS zones"
  type = list(object({
    zone_name = string
    vnet_link = bool
  }))
}


# ======================== GATEWAY ========================
variable "app_gateway_resource_group_name" {
  type        = string
  description = "The name of the gateway resource group in which all VON and ER resources will be created."
  default     = ""
}


# ======================== APP GATEWAY ========================
variable "app_appgateway_resource_group_name" {
  type        = string
  description = "The name of the resource group in which all application gateway resources will be created."
  default     = ""
}

variable "app_appgateway_name" {
  type        = string
  description = "The name of the application gateway."
  default     = ""
}