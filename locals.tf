locals {
  # ======================== GLOBAL ========================

  application = "hub-connectivity"
  app         = "hub"

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
  app_appgateway_name                = "agw-${var.env}-01"

}