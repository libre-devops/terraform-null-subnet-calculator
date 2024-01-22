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
