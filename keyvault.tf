resource "azurerm_resource_group" "app_security" {
  name     = local.app_keyvault_resource_group_name
  location = var.location
  tags     = merge(local.tags, { creation_date = "2025-10-31" })
}



resource "azurerm_key_vault" "app" {
  name                        = local.app_keyvault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.app_security.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  # enable_rbac_authorization   = true
  rbac_authorization_enabled = true
  sku_name                   = "standard"
  tags                       = merge(local.tags, { creation_date = "2025-10-31" })
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "private_ssh_key" {
  name         = "private-key-ssh-linux-vm"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = azurerm_key_vault.app.id
  content_type = "SSH Private Key"
}

resource "azurerm_key_vault_secret" "public_ssh_key" {
  name         = "public-key-ssh-linux-vm"
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.app.id
  content_type = "SSH Public Key"
}