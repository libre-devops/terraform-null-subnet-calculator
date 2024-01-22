output "base_cidr" {
  description = "The base CIDR given to the module for calculation"
  value       = var.base_cidr
}

output "subnet_first_ip" {
  description = "A map of subnet names to their first usable IP addresses."
  value = { for name, cidr in local.calculated_subnets :
    name => {
      first_ip = cidrhost(cidr, 1)
      last_ip  = cidrhost(cidr, pow(2, 32 - tonumber(split("/", cidr)[1])) - 3) # -3 accounts for network address, broadcast, and first IP
    }
  }
}

output "subnet_first_last_ip" {
  description = "A map of subnet names to their last usable IP addresses."
  value = { for name, cidr in local.calculated_subnets :
    name => {
      first_ip = cidrhost(cidr, 1)
      last_ip  = cidrhost(cidr, pow(2, 32 - tonumber(split("/", cidr)[1])) - 3) # -3 accounts for network address, broadcast, and first IP
    }
  }
}

output "subnet_last_ip" {
  description = "A map of subnet names to their first and last usable IP addresses."
  value = { for name, cidr in local.calculated_subnets :
    name => {
      last_ip = cidrhost(cidr, pow(2, 32 - tonumber(split("/", cidr)[1])) - 3) # -3 accounts for network address, broadcast, and first IP
    }
  }
}

output "subnet_mask_sizes" {
  description = "A map of subnet names to their mask sizes."
  value = { for name, details in local.final_subnet_details :
  name => details.mask_size }
}

output "subnet_names" {
  description = "A sorted list of subnet names calculated based on the provided details or sizes."
  value       = sort(local.subnet_names)
}

output "subnet_ranges" {
  description = "A list of subnet CIDR ranges corresponding to the sorted subnet names, ensuring consistent ordering."
  value       = [for i in sort(local.subnet_names) : local.calculated_subnets[i]]
}

output "subnet_sizes" {
  description = "A map of subnet names to the count of usable IPs in each subnet."
  value = { for name, cidr in local.calculated_subnets :
  name => pow(2, 32 - tonumber(split("/", cidr)[1])) - 2 } # -2 for network and broadcast addresses
}

output "subnets_map" {
  description = "A map of subnet names to their corresponding generated subnet CIDR ranges."
  value = { for name in local.subnet_names :
  name => local.calculated_subnets[name] }
}
