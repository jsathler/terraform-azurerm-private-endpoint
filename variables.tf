variable "location" {
  description = "The region where the Data Factory will be created. This parameter is required"
  type        = string
  default     = "northeurope"
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created. This parameter is required"
  type        = string
  nullable    = false
}
variable "tags" {
  description = "Tags to be applied to resources."
  type        = map(string)
  default     = null
}

variable "name_sufix_append" {
  description = "Define if all resources names should be appended with sufixes according to https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations."
  type        = bool
  default     = true
  nullable    = false
}

variable "private_endpoint" {
  description = <<DESCRIPTION
  Parameters to the private endpoint resource
  - name                              (required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created
  - subnet_id                         (required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint
  - application_security_group_ids    (optional) A list of Application Security Group IDs to be associated to this private endpoint
  - custom_network_interface_name     (optional) The custom name of the network interface attached to the private endpoint
  - private_ip_address                (optional) Specifies the static IP address within the private endpoint's subnet to be used
  - private_dns_zone_id               (optional) Specifies the Private DNS Zone ID to be used
  - is_manual_connection              (optional) Does the Private Endpoint require Manual Approval from the remote resource owner?. Defaults to false
  - private_connection_resource_id    (optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified
  - private_connection_resource_alias (optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private_connection_resource_id or private_connection_resource_alias must be specified
  - subresource_name                  (optional) A list of subresource names which the Private Endpoint is able to connect to.
  - request_message                   (optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if is_manual_connection is set to true

  DESCRIPTION
  type = object({
    name                              = string
    subnet_id                         = string
    application_security_group_ids    = optional(list(string), null)
    custom_network_interface_name     = optional(string, null)
    private_ip_address                = optional(string, null)
    private_dns_zone_id               = optional(string, null)
    is_manual_connection              = optional(bool, false)
    private_connection_resource_id    = optional(string, null)
    private_connection_resource_alias = optional(string, null)
    subresource_name                  = optional(string, null)
    request_message                   = optional(string, null)
  })
}
