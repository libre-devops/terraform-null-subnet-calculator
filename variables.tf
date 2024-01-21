variable "base_cidr" {
  description = "The base CIDR block"
  type        = string
}

variable "subnets" {
  description = "List of desired subnet mask sizes or map of subnet names to mask sizes"
  type        = any
  default     = []
}
