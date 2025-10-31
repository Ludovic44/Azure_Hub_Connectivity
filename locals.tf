locals {
  # ======================== GLOBAL ========================

  application = "hub-connectivity"
  app         = "hub"
 
  role             = "shared"
  role_abreviation = "shrd"

  tags = {
    environment   = var.environment
    application   = local.application
    created_by    = "ludovic.douaud@cellenza.com"
    managed_by    = "terraform"
    creation_date = "2025-10-27"
  }

  # ======================== VIRTUAL NETWORK ========================
  app_network_resource_group_name = "rg-${local.app}-network-${var.env}-01"
  app_vnet_frc_name               = "vnet-${local.app}-${var.loc}-${var.env}-01"
  pip_firewall_name               = "pip-${local.application}-firewall-${var.env}-01"


  # ======================== SECURITY ========================
  app_keyvault_resource_group_name = "rg-${local.app}-security-${var.env}-01"
  app_keyvault_name                = "kv-${local.app}${var.loc}${var.env}-01"


  # ======================== NVA VM ========================
  app_nva_vm_resource_group_name = "rg-${local.app}-nva-${var.env}-01"
  app_nva_vm_nic_name                = "nic-${local.app_nva_vm}"
  app_nva_vm = "vm-${local.application}-${local.role}-${var.env}-001"
  app_nva_vm_osdisk_name                              = "osdisk-${local.app_nva_vm}"
  app_nva_vm_admin_username                           = "adm-vm-orchestration-${var.env}"
 
 
  # ======================== FIREWALL ========================
  app_firewall_resource_group_name = "rg-${local.app}-firewall-${var.env}-01"
  app_firewall_name                = "fw-${local.app}-${var.loc}-${var.env}-01"


  # ======================== BASTION ========================
  app_bastion_resource_group_name = "rg-${local.app}-bastion-${var.env}-01"
  app_bastion_name                = "bas-${var.env}-01"
  pip_bastion_name                = "pip-${local.application}-bastion-${var.env}-01"


  # ======================== DNS PRIVATE RESOLVER ========================
  app_dns_resource_group_name = "rg-${local.app}-dns-${var.env}-01"
  app_dnsprivateresolver_name = "dnspr-${var.env}-01"


  # ======================== PRIVATE DNS ZONE ========================
  # app_dns_name                = "dns-${var.env}-01"


  # ======================== GATEWAY ========================
  app_gateway_resource_group_name = "rg-${local.app}-gateway-${var.env}-01"




  # ======================== APP GATEWAY ========================
  app_appgateway_resource_group_name = "rg-${local.app}-appgateway-${var.env}-01"
  # ------------------------ NO PRODUCTION ------------------------
  lb_noprod_resource_group_name = "rg-${local.application}-loadbalancing-noprod-001"
  # ........................ PUBLIC IP ........................
  pip_appgateway_noprod_name = "pip-${local.application}-appgateway-noprod-001"
  # ........................ APPLICATION GATEWAY ........................
  appgateway_noprod_name                        = "agw-noprod-001"
  appgateway_noprod_sku                         = "WAF_v2"
  appgateway_noprod_autoscale_configuration_min = 2
  appgateway_noprod_autoscale_configuration_max = 10
  appgateway_noprod_ip_configuration_name       = "appgw-noprod-ip-config"
  appgateway_noprod_policy_mode                 = "Detection" #Detection for NoProd and Prevention for Production
  # ........................ FRONTEND ........................ 
  appgateway_noprod_frontend_ip_configuration_name = "frontend-ip-appgw-noprod"
  appgateway_noprod_frontend_port_name             = "frontend-port-appgw-noprod"
  # ........................ BACKEND ........................
  # ExploreApp
  appgateway_noprod_exploreapp_backend_address_pool_name  = "backend-exploreapp-frontend-noprod-01"
  appgateway_noprod_exploreapp_backend_ip_address         = ["10.0.1.53"]
  appgateway_noprod_exploreapp_backend_http_settings_name = "http-settings-exploreapp-noprod-01"
  appgateway_noprod_exploreapp_backend_http_settings_path = "/path1/"
  # ........................ LISTENER ........................
  # ExploreApp
  appgateway_noprod_exploreapp_http_listener_name = "http-listener-exploreapp-noprod-01"
  # appgateway_noprod_http_listener_frontend_ip_configuration_name = "appgw-noprod-frontend-ip"
  # appgateway_noprod_http_listener_frontend_port_name             = "appgw-noprod-frontend-port"
  # ........................ ROUTING ........................
  # ExploreApp
  # appgateway_noprod_routing_name                       = "appgw-noprod-routing-rule"
  appgateway_noprod_exploreapp_routing_name      = "routing-rule-exploreapp-noprod-01"
  appgateway_noprod_exploreapp_routing_rule_type = "Basic"
  # appgateway_noprod_exploreapp_routing_http_listener_name         = "http-listener-exploreapp-noprod-01"
  appgateway_noprod_exploreapp_routing_http_listener_name = local.appgateway_noprod_exploreapp_http_listener_name
  # appgateway_noprod_exploreapp_routing_backend_address_pool_name  = "backend-exploreapp-frontend-noprod-01"
  appgateway_noprod_exploreapp_routing_backend_address_pool_name = local.appgateway_noprod_exploreapp_backend_address_pool_name
  # appgateway_noprod_exploreapp_routing_backend_http_settings_name = "http-settings-exploreapp-noprod-01"
  appgateway_noprod_exploreapp_routing_backend_http_settings_name = local.appgateway_noprod_exploreapp_backend_http_settings_name
  # ........................ POLICY ........................
  # ExploreApp
  appgateway_noprod_waf_policy_name = "wafp-exploreapp-noprod-001"



  # ------------------------ PRODUCTION ------------------------
  lb_prod_resource_group_name = "rg-${local.application}-loadbalancing-${var.env}-001"
  
}