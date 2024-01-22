```hcl
locals {
  hub_vnet_address_space    = "10.0.0.0/12"
  spoke_vnet_address_space  = "192.168.0.0/23"
  spoke2_vnet_address_space = "192.168.4.0/24"
}

module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

module "hub_subnet_calculator" {
  source = "cyber-scot/subnet-calculator/null"

  base_cidr = local.hub_vnet_address_space
  subnets = {
    "AzureBastionSubnet" = {
      mask_size = 27
      netnum    = 0
    },
    "GatewaySubnet" = {
      mask_size = 26
      netnum    = 1
    }
  }
}

output "hub_calculated_subnets" {
  value = module.hub_subnet_calculator.*
}

module "hub_network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-hub-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = toset([local.hub_vnet_address_space])

  subnets = {
    (module.hub_subnet_calculator.subnet_names[0]) = {
      address_prefixes = toset([module.hub_subnet_calculator.subnet_ranges[0]])
    }
    (module.hub_subnet_calculator.subnet_names[1]) = {
      address_prefixes = toset([module.hub_subnet_calculator.subnet_ranges[1]])
    }
  }
}

# Example with a list of sizes (automatic naming)
module "spoke_subnet_calculator" {
  source = "cyber-scot/subnet-calculator/null"

  base_cidr    = local.spoke_vnet_address_space
  subnet_sizes = [28, 26, 25] # Automatic naming as subnet1, subnet2, subnet3
}


output "spoke_calculated_subnets" {
  value = module.spoke_subnet_calculator.*
}

module "spoke_network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = toset([local.spoke_vnet_address_space])

  subnets = {
    (module.spoke_subnet_calculator.subnet_names[0]) = {
      address_prefixes = toset([module.spoke_subnet_calculator.subnet_ranges[0]])
    }
    (module.spoke_subnet_calculator.subnet_names[1]) = {
      address_prefixes = toset([module.spoke_subnet_calculator.subnet_ranges[1]])
    }
    (module.spoke_subnet_calculator.subnet_names[2]) = {
      address_prefixes = toset([module.spoke_subnet_calculator.subnet_ranges[2]])
    }
  }
}

# Example with a list of sizes (automatic naming)
module "spoke2_subnet_calculator" {
  source = "cyber-scot/subnet-calculator/null"

  base_cidr    = local.spoke2_vnet_address_space
  subnet_sizes = [28, 26, 26] # Automatic naming as subnet1, subnet2, subnet3
}

module "spoke2_network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-${var.short}-${var.loc}-${var.env}-02"
  vnet_location      = module.rg.rg_location
  vnet_address_space = toset([local.spoke2_vnet_address_space])

  subnets = { for i, name in module.spoke2_subnet_calculator.subnet_names :
    name => {
      address_prefixes = toset([module.spoke2_subnet_calculator.subnet_ranges[i]])
    }
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.88.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.2 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub_network"></a> [hub\_network](#module\_hub\_network) | cyber-scot/network/azurerm | n/a |
| <a name="module_hub_subnet_calculator"></a> [hub\_subnet\_calculator](#module\_hub\_subnet\_calculator) | cyber-scot/subnet-calculator/null | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | cyber-scot/rg/azurerm | n/a |
| <a name="module_spoke2_network"></a> [spoke2\_network](#module\_spoke2\_network) | cyber-scot/network/azurerm | n/a |
| <a name="module_spoke2_subnet_calculator"></a> [spoke2\_subnet\_calculator](#module\_spoke2\_subnet\_calculator) | cyber-scot/subnet-calculator/null | n/a |
| <a name="module_spoke_network"></a> [spoke\_network](#module\_spoke\_network) | cyber-scot/network/azurerm | n/a |
| <a name="module_spoke_subnet_calculator"></a> [spoke\_subnet\_calculator](#module\_spoke\_subnet\_calculator) | cyber-scot/subnet-calculator/null | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [external_external.detect_os](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.generate_timestamp](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.client_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Regions"></a> [Regions](#input\_Regions) | Converts shorthand name to longhand name via lookup on map list | `map(string)` | <pre>{<br>  "eus": "East US",<br>  "euw": "West Europe",<br>  "uks": "UK South",<br>  "ukw": "UK West"<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | The env variable, for example - prd for production. normally passed via TF\_VAR. | `string` | `"prd"` | no |
| <a name="input_loc"></a> [loc](#input\_loc) | The loc variable, for the shorthand location, e.g. uks for UK South.  Normally passed via TF\_VAR. | `string` | `"uks"` | no |
| <a name="input_short"></a> [short](#input\_short) | The shorthand name of to be used in the build, e.g. cscot for CyberScot.  Normally passed via TF\_VAR. | `string` | `"cscot"` | no |
| <a name="input_static_tags"></a> [static\_tags](#input\_static\_tags) | The tags variable | `map(string)` | <pre>{<br>  "Contact": "info@cyber.scot",<br>  "CostCentre": "671888",<br>  "ManagedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hub_calculated_subnets"></a> [hub\_calculated\_subnets](#output\_hub\_calculated\_subnets) | n/a |
| <a name="output_spoke_calculated_subnets"></a> [spoke\_calculated\_subnets](#output\_spoke\_calculated\_subnets) | n/a |
