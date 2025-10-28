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
  app_network_resource_group_name = "rg-${local.app}-network-${var.env}-001"
  app_vnet_frc_name               = "vnet-${local.app}-${var.loc}-${var.env}-001"


  # ======================== FIREWALL ========================
  app_firewall_resource_group_name = "rg-${local.app}-firewall-${var.env}-001"
  app_firewall_name                = "fw-${local.app}-${var.loc}-${var.env}-001"


  # ======================== BASTION ========================
  app_bastion_resource_group_name = "rg-${local.app}-bastion-${var.env}-001"
  app_bastion_name                = "bas-${local.app}-${var.loc}-${var.env}-001"


  # ======================== DNS ========================
  app_dns_resource_group_name = "rg-${local.app}-dns-${var.env}-001"
  app_dns_name                = "dns-${local.app}-${var.loc}-${var.env}-001"


  # ======================== APP GATEWAY ========================
  app_gateway_resource_group_name = "rg-${local.app}-appgateway-${var.env}-001"
  app_gateway_name                = "ag-${local.app}-${var.loc}-${var.env}-001"

}