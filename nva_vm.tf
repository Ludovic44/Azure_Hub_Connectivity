resource "azurerm_resource_group" "app_nva_vm" {
  name     = local.app_nva_vm_resource_group_name
  location = var.location
  tags     = merge(local.tags, { creation_date = "2025-10-31" })
}

resource "azurerm_network_interface" "app_nva_vm" {
  name                = local.app_nva_vm_nic_name
  location            = azurerm_resource_group.app_nva_vm.location
  resource_group_name = azurerm_resource_group.app_nva_vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = merge(local.tags, { creation_date = "2025-10-31" })
}

resource "azurerm_linux_virtual_machine" "app_nva_vm" {
  name                = local.app_nva_vm
  resource_group_name = azurerm_resource_group.app_nva_vm.name
  location            = azurerm_resource_group.app_nva_vm.location
  size                = var.app_nva_vm_orchestration_size
  admin_username      = local.app_nva_vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.app_nva_vm.id,
  ]

  admin_ssh_key {
    username   = local.app_nva_vm_admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    # storage_account_type = "Premium_LRS"
    disk_size_gb = "60"
    name         = local.app_nva_vm_osdisk_name
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  tags = merge(local.tags, { creation_date = "2025-10-31" })
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "app_nva_vm" {
  virtual_machine_id = azurerm_linux_virtual_machine.app_nva_vm.id
  location           = azurerm_resource_group.app_nva_vm.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "60"
    webhook_url     = "https://sample-webhook-url.example.com"
  }

  tags = merge(local.tags, { creation_date = "2025-10-31" })
}