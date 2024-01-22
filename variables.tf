variable "base_cidr" {
  description = "The base CIDR block"
  type        = string
}

variable "subnets" {
  description = "Map of subnet names to their desired mask sizes and netnum"
  type = map(object({
    mask_size = number
    netnum    = number
  }))
  default = {}
}

variable "subnet_sizes" {
  description = "List of subnet sizes if names are to be generated"
  type        = list(number)
  default     = []
}
