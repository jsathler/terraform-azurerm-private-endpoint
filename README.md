<!-- BEGIN_TF_DOCS -->
# Azure Private Endpoint Terraform module

Terraform module which creates Azure Private Endpoint resources on Azure.

Supported Azure services:

* [Azure Private Endpoint](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.70.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint_application_security_group_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The region where the Data Factory will be created. This parameter is required | `string` | `"northeurope"` | no |
| <a name="input_name_sufix_append"></a> [name\_sufix\_append](#input\_name\_sufix\_append) | Define if all resources names should be appended with sufixes according to https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations. | `bool` | `true` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Parameters to the private endpoint resource<br>  - name                              (required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created<br>  - subnet\_id                         (required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint<br>  - application\_security\_group\_ids    (optional) A list of Application Security Group IDs to be associated to this private endpoint<br>  - custom\_network\_interface\_name     (optional) The custom name of the network interface attached to the private endpoint<br>  - private\_ip\_address                (optional) Specifies the static IP address within the private endpoint's subnet to be used<br>  - private\_dns\_zone\_id               (optional) Specifies the Private DNS Zone ID to be used<br>  - is\_manual\_connection              (optional) Does the Private Endpoint require Manual Approval from the remote resource owner?. Defaults to false<br>  - private\_connection\_resource\_id    (optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private\_connection\_resource\_id or private\_connection\_resource\_alias must be specified<br>  - private\_connection\_resource\_alias (optional) The Service Alias of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. One of private\_connection\_resource\_id or private\_connection\_resource\_alias must be specified<br>  - subresource\_name                  (optional) A list of subresource names which the Private Endpoint is able to connect to.<br>  - request\_message                   (optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if is\_manual\_connection is set to true | <pre>object({<br>    name                              = string<br>    subnet_id                         = string<br>    application_security_group_ids    = optional(list(string), null)<br>    custom_network_interface_name     = optional(string, null)<br>    private_ip_address                = optional(string, null)<br>    private_dns_zone_id               = optional(string, null)<br>    is_manual_connection              = optional(bool, false)<br>    private_connection_resource_id    = optional(string, null)<br>    private_connection_resource_alias = optional(string, null)<br>    subresource_name                  = optional(string, null)<br>    request_message                   = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the resources will be created. This parameter is required | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_ip_configuration"></a> [ip\_configuration](#output\_ip\_configuration) | n/a |
| <a name="output_network_interface"></a> [network\_interface](#output\_network\_interface) | n/a |

## Examples
```hcl
module "private-endpoint" {
  source              = "jsathler/private-endpoint/azurerm"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  private_endpoint = {
    name                           = "${azurerm_storage_account.default.name}-blob"
    subnet_id                      = module.vnet.subnet_ids.default-snet
    private_connection_resource_id = azurerm_storage_account.default.id
    subresource_name               = "blob"

    application_security_group_ids = [azurerm_application_security_group.default.id]
    private_dns_zone_id            = module.private-zone.private_zone_ids["privatelink.blob.core.windows.net"]
  }
}
```
More examples in ./examples folder
<!-- END_TF_DOCS -->