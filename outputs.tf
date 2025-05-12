output "gateway_public_ip" {
  value = azurerm_public_ip.gateway_ip.ip_address
}