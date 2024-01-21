variable "base_cidr" {
  description = "The base CIDR block"
  type        = string
}

variable "subnet_sizes" {
  description = "List of desired subnet mask sizes"
  type        = list(number)
  default     = []
}

variable "subnets" {
  description = "Map of custom subnet names to mask sizes"
  type        = map(number)
  default     = {}
}

