provider "azurerm" {
  features {}
}

# 1. Erőforráscsoport
resource "azurerm_resource_group" "rg" {
  name     = "minta-rg-hub-spoke"
  location = "North Europe"
}

# 2. Hub VNet (Központ)
resource "azurerm_virtual_network" "hub" {
  name                = "minta-vnet-hub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.100.0.0/16"]
}

# Hub Alhálózat
resource "azurerm_subnet" "hub_subnet" {
  name                 = "minta-subnet-hub"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.1.0/24"]
}

# 3. Spoke 1 VNet (Munkaterület / Alkalmazás)
resource "azurerm_virtual_network" "spoke1" {
  name                = "minta-spoke-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.200.0.0/16"]
}

# Spoke 1 Alhálózat
resource "azurerm_subnet" "spoke1_subnet" {
  name                 = "minta-subnet-spoke-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefixes     = ["10.200.1.0/24"]
}

# 4. Peering: Hub -> Spoke 1 irány
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                      = "minta-peer-hub-to-spoke-1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# 5. Peering: Spoke 1 -> Hub irány
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                      = "minta-peer-spoke-1-to-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}