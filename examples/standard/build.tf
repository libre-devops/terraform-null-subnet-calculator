module "subnet_calculator" {
  source    = "../../"
  base_cidr = "10.4.2.128/25"
  subnets = {
    "AzureBastionSubnet" = 27
    "GatewaySubnet"      = 26
  }
}

output "calculated_subnets" {
  value = module.subnet_calculator.subnets
}
