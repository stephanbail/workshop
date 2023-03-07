
provider "azurerm" {
  alias           = "customer"
  subscription_id = var.customer_subscription_id
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_network_interface" "nic-cus-we-avd-d-01" {
  provider = azurerm.customer

  name                = (format("nic-cus-we-avd-d-%s", var.avd_numeric_suffix))
  location            = var.location
  resource_group_name = var.avd-resource-group

  ip_configuration {
    name                          = (format("ipconfig-cus-we-avd-d-%s", var.avd_numeric_suffix))
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-cus-we-avd-d-01.id
  }

  tags = {
    Kundennummer = "1000"
  }
}

resource "azurerm_public_ip" "pip-cus-we-avd-d-01" {
  provider = azurerm.customer

  name                = (format("pip-cus-we-avd-d-%s", var.avd_numeric_suffix))
  location            = var.location
  resource_group_name = var.avd-resource-group
  allocation_method   = "Static"

  tags = {
    Kundennummer = "1000"
  }
}

// Create a Virtual machine and use marketplace publisher id microsoftwindowsdesktop and product id windows-11 and plan id win11-21h2-pro and use size Standard_D2s_v3


resource "azurerm_managed_disk" "disk-cus-we-avd-d" {
  provider             = azurerm.customer
  name                 = (format("disk-cus-we-avd-d-%s", var.avd_numeric_suffix))
  location             = var.location
  resource_group_name  = var.avd-resource-group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Copy"
  source_resource_id   = var.azure_managed_disk_id
  disk_size_gb         = "127"

  tags = {
    Kundennummer = "1000"
  }
}

resource "azurerm_virtual_machine" "vm-cus-we-avd-d" {
  provider            = azurerm.customer
  resource_group_name = var.avd-resource-group
  location            = var.location
  vm_size             = "Standard_D4_v4"
  name                = (format("vm-cus-we-avd-d-%s", var.avd_numeric_suffix))

  network_interface_ids = [
    azurerm_network_interface.nic-cus-we-avd-d-01.id
  ]

  storage_os_disk {
    name              = (format("disk-cus-we-avd-d-%s", var.avd_numeric_suffix))
    os_type           = "Windows"
    create_option     = "Attach"
    caching           = "ReadWrite"
    managed_disk_type = "StandardSSD_LRS"
    managed_disk_id   = azurerm_managed_disk.disk-cus-we-avd-d.id
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
    Kundennummer = "1000"
  }
}
