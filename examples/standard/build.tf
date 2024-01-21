module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

module "subnet_calculator" {
  source    = "cyber-scot/subnet-calculator/null"
  base_cidr = "10.4.2.128/25"
  subnets = {
    "AzureBastionSubnet" = 27
    "GatewaySubnet"      = 26
  }
}

output "calculated_subnet_names" {
  value = module.subnet_calculator.subnet_names
}

output "calculated_subnet_ranges" {
  value = module.subnet_calculator.subnet_ranges
}

output "calculated_subnets" {
  value = module.subnet_calculator.subnets
}

module "network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    (module.subnet_calculator.subnet_names[0]) = {
      address_prefixes = toset([module.subnet_calculator.subnet_ranges[0]])
    }
    (module.subnet_calculator.subnet_names[1]) = {
      address_prefixes = toset([module.subnet_calculator.subnet_ranges[1]])
    }
  }
}
