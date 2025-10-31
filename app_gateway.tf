
# ======================== LOAD BALANCING ========================
# ------------------------ NO PRODUCTION ------------------------
resource "azurerm_resource_group" "lb_noprod" {
  name     = local.lb_noprod_resource_group_name
  location = var.location
  tags     = local.tags
}

# ------------------------ PRODUCTION ------------------------
resource "azurerm_resource_group" "lb_prod" {
  name     = local.lb_prod_resource_group_name
  location = var.location
  tags     = local.tags
}

# # ======================== PUBLIC IP ========================

# resource "azurerm_public_ip" "appgateway_noprod" {
#   name                = local.pip_appgateway_noprod_name
#   resource_group_name = azurerm_resource_group.lb_noprod.name
#   location            = azurerm_resource_group.lb_noprod.location
#   allocation_method   = "Static"
# }


# # ======================== WAF POLICY ========================
# # Create a Web Application Firewall (WAF) policy
# resource "azurerm_web_application_firewall_policy" "exploreapp_noprod" {
#   name                = local.appgateway_noprod_waf_policy_name
#   resource_group_name = azurerm_resource_group.lb_noprod.name
#   location            = azurerm_resource_group.lb_noprod.location

#   # Configure the policy settings
#   policy_settings {
#     enabled                                   = true
#     file_upload_limit_in_mb                   = 100
#     js_challenge_cookie_expiration_in_minutes = 5
#     max_request_body_size_in_kb               = 128
#     mode                                      = local.appgateway_noprod_policy_mode
#     request_body_check                        = true
#     request_body_inspect_limit_in_kb          = 128
#   }

#   # Define managed rules for the WAF policy
#   managed_rules {
#     managed_rule_set {
#       type    = "OWASP"
#       version = "3.2"
#     }
#   }

#   # Define a custom rule to block traffic from a specific IP address
#   custom_rules {
#     name      = "BlockSpecificIP"
#     priority  = 1
#     rule_type = "MatchRule"

#     match_conditions {
#       match_variables {
#         variable_name = "RemoteAddr"
#       }
#       operator           = "IPMatch"
#       negation_condition = false
#       match_values       = ["192.168.1.1"] # Replace with the IP address to block
#     }

#     action = "Block"
#   }
# }


# # ======================== APPLICATION GATEWAY ========================
# resource "azurerm_application_gateway" "no_prod" {
#   name                = local.appgateway_noprod_name
#   resource_group_name = azurerm_resource_group.lb_noprod.name
#   location            = azurerm_resource_group.lb_noprod.location

#   enable_http2 = true

#   # Configure the SKU and capacity
#   sku {
#     name = local.appgateway_noprod_sku
#     tier = local.appgateway_noprod_sku
#     # capacity = 2 #unuseful with autoscaling settings
#   }

#   # Enable autoscaling (optional)
#   autoscale_configuration {
#     min_capacity = local.appgateway_noprod_autoscale_configuration_min
#     max_capacity = local.appgateway_noprod_autoscale_configuration_max
#   }

#   # Configure the gateway's IP settings
#   gateway_ip_configuration {
#     name      = local.appgateway_noprod_ip_configuration_name
#     subnet_id = azurerm_subnet.app_subnets_frc["snet-hub-appgateway-npd-01"].id
#   }

#   # ------------------------ FRONTEND ------------------------
#   # Configure the frontend IP
#   frontend_ip_configuration {
#     name                 = local.appgateway_noprod_frontend_ip_configuration_name
#     public_ip_address_id = azurerm_public_ip.appgateway_noprod.id
#   }

#   # Define the frontend port
#   frontend_port {
#     name = local.appgateway_noprod_frontend_port_name
#     port = 80
#   }

#   # ------------------------ BACKEND ------------------------
#   # ........................ EXPLORE APP ........................
#   # Define the backend address pool with IP addresses
#   backend_address_pool {
#     name         = local.appgateway_noprod_exploreapp_backend_address_pool_name
#     ip_addresses = local.appgateway_noprod_exploreapp_backend_ip_address # Replace with your backend IP addresses
#   }
#   # Configure backend HTTP settings
#   backend_http_settings {
#     name                  = local.appgateway_noprod_exploreapp_backend_http_settings_name
#     cookie_based_affinity = "Disabled"
#     # path                  = local.appgateway_noprod_exploreapp_backend_http_settings_path
#     port            = 80
#     protocol        = "Http"
#     request_timeout = 60
#   }

#   # ........................ APPLICATION 2 ........................
#   # Define the backend address pool with IP addresses
#   # backend_address_pool {
#   #   name         = ""
#   #   ip_addresses = ""
#   # }
#   # Configure backend HTTP settings
#   # backend_http_settings {
#   #   name                  = ""
#   #   cookie_based_affinity = "Disabled"
#   #   # path                  = "/path1/"
#   #   port            = 80
#   #   protocol        = "Http"
#   #   request_timeout = 60
#   # }

#   # ------------------------ LISTENER ------------------------
#   # ........................ EXPLORE APP ........................
#   # Define the HTTP listener
#   http_listener {
#     name                           = local.appgateway_noprod_exploreapp_http_listener_name
#     frontend_ip_configuration_name = local.appgateway_noprod_frontend_ip_configuration_name
#     frontend_port_name             = local.appgateway_noprod_frontend_port_name
#     protocol                       = "Http"
#   }

#   # ........................ APPLICATION 2 ........................
#   # Define the HTTP listener
#   # http_listener {
#   #   name                           = ""
#   #   frontend_ip_configuration_name = ""
#   #   frontend_port_name             = ""
#   #   protocol                       = ""
#   # }

#   # ------------------------ ROUTING ------------------------
#   # Define the request routing rule
#   request_routing_rule {
#     name                       = local.appgateway_noprod_exploreapp_routing_name
#     priority                   = 9
#     rule_type                  = local.appgateway_noprod_exploreapp_routing_rule_type
#     http_listener_name         = local.appgateway_noprod_exploreapp_routing_http_listener_name
#     backend_address_pool_name  = local.appgateway_noprod_exploreapp_routing_backend_address_pool_name
#     backend_http_settings_name = local.appgateway_noprod_exploreapp_routing_backend_http_settings_name
#   }


#   # ------------------------ POLICY ------------------------
#   # Associate the WAF policy with the Application Gateway
#   firewall_policy_id                = azurerm_web_application_firewall_policy.exploreapp_noprod.id
#   force_firewall_policy_association = true
#   # waf_configuration {
#   #   enabled          = true
#   #   firewall_mode    = local.appgateway_noprod_policy_mode
#   #   rule_set_type    = "OWASP"
#   #   rule_set_version = "3.2"
#   # }
# }