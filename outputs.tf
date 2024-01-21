output "subnet_names" {
  description = "List of subnet names"
  value       = local.subnet_names
}

output "subnet_ranges" {
  description = "List of subnet CIDR ranges"
  value       = local.subnet_ranges
}

output "subnets" {
  description = "A map of subnet names and their CIDR blocks"
  value       = local.calculated_subnets
}
