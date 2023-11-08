locals {
  tags = merge(var.tags, { ManagedByTerraform = "True" })
}

resource "azurerm_private_endpoint" "default" {
  name                          = var.name_sufix_append ? "${var.private_endpoint.name}-pep" : var.private_endpoint.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  subnet_id                     = var.private_endpoint.subnet_id
  custom_network_interface_name = var.private_endpoint.custom_network_interface_name
  tags                          = local.tags

  private_service_connection {
    name                              = var.name_sufix_append ? "${var.private_endpoint.name}-pep" : var.private_endpoint.name
    is_manual_connection              = var.private_endpoint.is_manual_connection
    private_connection_resource_id    = var.private_endpoint.private_connection_resource_id
    private_connection_resource_alias = var.private_endpoint.private_connection_resource_alias
    subresource_names                 = [var.private_endpoint.subresource_name]
    request_message                   = var.private_endpoint.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_endpoint.private_dns_zone_id == null ? [] : toset(["zone_group"])
    content {
      name                 = split("/", var.private_endpoint.private_dns_zone_id)[8]
      private_dns_zone_ids = [var.private_endpoint.private_dns_zone_id]
    }
  }

  dynamic "ip_configuration" {
    for_each = var.private_endpoint.private_ip_address == null ? [] : toset(["static_ip"])
    content {
      name               = "static"
      private_ip_address = var.private_endpoint.private_ip_address
      subresource_name   = var.private_service_connection.subresource_name
    }
  }
}

resource "azurerm_private_endpoint_application_security_group_association" "default" {
  for_each                      = var.private_endpoint.application_security_group_ids == null ? {} : { for key, value in var.private_endpoint.application_security_group_ids : key => value }
  private_endpoint_id           = azurerm_private_endpoint.default.id
  application_security_group_id = each.value
}
