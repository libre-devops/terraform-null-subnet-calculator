locals {
  base_cidr_mask_size = tonumber(split("/", var.base_cidr)[1])

  is_map = type(var.subnets) == "map"

  subnets_map = local.is_map ? var.subnets : { for i, size in var.subnets : format("subnet%s", i + 1) => size }

  calculated_subnets = {
    for subnet_name, desired_mask_size in local.subnets_map :
    subnet_name => cidrsubnet(var.base_cidr, desired_mask_size - local.base_cidr_mask_size, index(keys(local.subnets_map), subnet_name))
  }

  subnet_names  = keys(local.calculated_subnets)
  subnet_ranges = values(local.calculated_subnets)
}
