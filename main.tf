locals {
  base_cidr_mask_size = tonumber(split("/", var.base_cidr)[1])

  # Check if custom names are provided
  use_custom_names = length(var.subnets) > 0

  # Use subnets if provided, else generate names for subnet_sizes
  subnets_map = local.use_custom_names ? var.subnets : {
    for i, size in var.subnet_sizes : format("subnet%s", i + 1) => size
  }

  calculated_subnets = {
    for subnet_name, desired_mask_size in local.subnets_map :
    subnet_name => cidrsubnet(var.base_cidr, desired_mask_size - local.base_cidr_mask_size, index(keys(local.subnets_map), subnet_name))
  }

  subnet_names  = keys(local.calculated_subnets)
  subnet_ranges = values(local.calculated_subnets)
}
