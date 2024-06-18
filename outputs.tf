output "id" {
  value = azurerm_private_endpoint.default.id
}

output "network_interface" {
  value = azurerm_private_endpoint.default.network_interface
}

output "ip_configuration" {
  value = azurerm_private_endpoint.default.ip_configuration
}

output "private_ip_address" {
  value = azurerm_private_endpoint.default.private_service_connection[0].private_ip_address
}
