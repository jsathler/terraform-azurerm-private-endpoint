locals {
  prefix = "${basename(path.cwd)}-${random_string.default.result}"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${local.prefix}-rg"
  location = "northeurope"
}

resource "random_string" "default" {
  length    = 6
  min_lower = 6
}

resource "azurerm_storage_account" "default" {
  name                     = "${lower(replace(local.prefix, "/[^A-Za-z0-9]/", ""))}st"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_security_group" "default" {
  name                = "${local.prefix}-asg"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "vnet" {
  source              = "jsathler/network/azurerm"
  version             = "0.0.2"
  name                = basename(path.cwd)
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]

  subnets = {
    default = {
      address_prefixes   = ["10.0.0.0/24"]
      nsg_create_default = false
    }
  }
}

module "private-zone" {
  source              = "jsathler/dns-zone/azurerm"
  version             = "0.0.1"
  resource_group_name = azurerm_resource_group.default.name
  zones = {
    "privatelink.blob.core.windows.net" = {
      private = true
      vnets = {
        "${basename(path.cwd)}-vnet" = { id = module.vnet.vnet_id }
      }
    }
  }
}

module "private-endpoint" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  private_endpoint = {
    name                           = "${azurerm_storage_account.default.name}-blob"
    subnet_id                      = module.vnet.subnet_ids.default-snet
    private_connection_resource_id = azurerm_storage_account.default.id
    subresource_name               = "blob"

    application_security_group_ids = [azurerm_application_security_group.default.id]
    private_dns_zone_id            = module.private-zone.private_zone_ids["privatelink.blob.core.windows.net"]

    #If you want to specify the ip address to be used, uncomment the line below
    #private_ip_address  = "10.0.0.4"
  }
}

output "private-endpoint" {
  value = module.private-endpoint
}
