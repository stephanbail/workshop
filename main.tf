terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }

  backend "azurerm" {
    subscription_id      = ""
    resource_group_name  = "rg-sha-we-com-d-01"
    storage_account_name = "itscterraform"
    container_name       = "terraform"
    key                  = "itsc-yourname.tfstate"
  }
}


//////////////////////////////////////////////////////////////
//////// 1. The customers network and infrastructure /////////
//////////////////////////////////////////////////////////////


provider "azurerm" {
  alias           = "customer"
  subscription_id = var.customer_subscription_id
  tenant_id       = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "rg-cus-we-avd-d-01" {
  provider = azurerm.customer

  name     = "rg-cus-we-avd-d-01"
  location = var.location
  tags = {
    Kundennummer = "1000"
  }
}

// Create a windows virtual machine and a public IP address

resource "azurerm_virtual_network" "vnet-cus-we-avd-d-01" {
  provider = azurerm.customer

  name                = "vnet-cus-we-avd-d-01"
  address_space       = ["10.84.1.0/24"]
  location            = azurerm_resource_group.rg-cus-we-avd-d-01.location
  resource_group_name = azurerm_resource_group.rg-cus-we-avd-d-01.name

  tags = {
    Kundennummer = "1000"
  }
}

resource "azurerm_subnet" "subnet-cus-we-avd-d-01" {
  provider = azurerm.customer

  name                 = "subnet-cus-we-avd-d-01"
  resource_group_name  = azurerm_resource_group.rg-cus-we-avd-d-01.name
  virtual_network_name = azurerm_virtual_network.vnet-cus-we-avd-d-01.name
  address_prefixes     = ["10.84.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-cus-we-avd-d-01" {
  provider = azurerm.customer

  name                = "nsg-cus-we-avd-d-01"
  location            = azurerm_resource_group.rg-cus-we-avd-d-01.location
  resource_group_name = azurerm_resource_group.rg-cus-we-avd-d-01.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Kundennummer = "1000"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-cus-we-avd-d-01" {
  provider = azurerm.customer

  subnet_id                 = azurerm_subnet.subnet-cus-we-avd-d-01.id
  network_security_group_id = azurerm_network_security_group.nsg-cus-we-avd-d-01.id
}

module "avd-01" {
  source             = "./Modules/client"
  location           = var.location
  avd-resource-group = azurerm_resource_group.rg-cus-we-avd-d-01.name
  subnet_id          = azurerm_subnet.subnet-cus-we-avd-d-01.id
  avd_numeric_suffix = "01"
}

module "avd-02" {
  source             = "./Modules/client"
  location           = var.location
  avd-resource-group = azurerm_resource_group.rg-cus-we-avd-d-01.name
  subnet_id          = azurerm_subnet.subnet-cus-we-avd-d-01.id
  avd_numeric_suffix = "02"
}


module "avd-03" {
  source             = "./Modules/client"
  location           = var.location
  avd-resource-group = azurerm_resource_group.rg-cus-we-avd-d-01.name
  subnet_id          = azurerm_subnet.subnet-cus-we-avd-d-01.id
  avd_numeric_suffix = "03"
}
