locals {
  base_cidr_mask_size = tonumber(split("/", var.base_cidr)[1])

  # Determine if custom subnet details are provided
  use_custom_details = length(var.subnets) > 0

  # Use provided subnet details or generate subnet names and use default netnum and mask size
  final_subnet_details = local.use_custom_details ? var.subnets : {
    for i, size in var.subnet_sizes : format("subnet%s", i + 1) => {
      mask_size = size
      netnum    = i # Default netnum, can be changed to another logic
    }
  }

  calculated_subnets = {
    for subnet_name, details in local.final_subnet_details :
    subnet_name => cidrsubnet(var.base_cidr, details.mask_size - local.base_cidr_mask_size, details.netnum)
  }

  subnet_names = sort(keys(local.calculated_subnets))
}