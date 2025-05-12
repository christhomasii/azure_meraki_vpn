provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_prefix]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_public_ip" "gateway_ip" {
  name                = var.gateway_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = var.vnet_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gateway_ip.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_local_network_gateway" "meraki_lng" {
  name                = var.local_gateway_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  gateway_address     = var.meraki_public_ip
  address_space       = [var.meraki_address_prefix]
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                            = var.connection_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vnet_gateway.id
  local_network_gateway_id        = azurerm_local_network_gateway.meraki_lng.id
  type                            = "IPsec"
  connection_protocol             = "IKEv2"
  shared_key                      = var.shared_key
}