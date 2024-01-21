locals {
  base_cidr_mask_size = tonumber(split("/", var.base_cidr)[1])
  calculated_subnets = {
    for subnet_name, desired_mask_size in var.subnets :
    subnet_name => cidrsubnet(var.base_cidr, desired_mask_size - local.base_cidr_mask_size, index(keys(var.subnets), subnet_name))
  }

  subnet_names  = keys(local.calculated_subnets)
  subnet_ranges = values(local.calculated_subnets)
}

