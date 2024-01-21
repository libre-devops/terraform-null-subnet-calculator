locals {
  hub_vnet_address_space   = "10.0.0.0/12"
  spoke_vnet_address_space = "192.168.0.0/23"
}

module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

module "hub_subnet_calculator" {
  source    = "cyber-scot/subnet-calculator/null"
  base_cidr = local.hub_vnet_address_space
  subnets = {
    "AzureBastionSubnet" = 27
    "GatewaySubnet"      = 26
  }
}

output "calculated_subnet_names" {
  value = module.hub_subnet_calculator.subnet_names
}

output "calculated_subnet_ranges" {
  value = module.hub_subnet_calculator.subnet_ranges
}

output "calculated_subnets" {
  value = module.hub_subnet_calculator.subnets
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
    (module.hub_network.subnet_names[1]) = {
      address_prefixes = toset([module.hub_subnet_calculator.subnet_ranges[1]])
    }
  }
}

# Example with a list of sizes (automatic naming)
module "spoke_subnet_calculator" {
  source    = "cyber-scot/subnet-calculator/null"
  base_cidr = local.spoke_vnet_address_space
  subnets   = [28, 26, 25] # Automatic naming as subnet_1, subnet_2, subnet_3
}



# Outputs can be accessed as before


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
