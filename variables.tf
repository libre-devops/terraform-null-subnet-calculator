variable "base_cidr" {
  description = "The base CIDR block"
  type        = string
}

variable "subnets" {
  description = "A map of subnet names and desired subnet mask sizes"
  type        = map(number)
}
