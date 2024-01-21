```hcl
locals {
  base_cidr_mask_size = tonumber(split("/", var.base_cidr)[1])
  calculated_subnets = {
    for subnet_name, desired_mask_size in var.subnets :
    subnet_name => cidrsubnet(var.base_cidr, desired_mask_size - local.base_cidr_mask_size, index(keys(var.subnets), subnet_name))
  }

  subnet_names  = keys(local.calculated_subnets)
  subnet_ranges = values(local.calculated_subnets)
}

```
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_cidr"></a> [base\_cidr](#input\_base\_cidr) | The base CIDR block | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A map of subnet names and desired subnet mask sizes | `map(number)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | List of subnet names |
| <a name="output_subnet_ranges"></a> [subnet\_ranges](#output\_subnet\_ranges) | List of subnet CIDR ranges |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A map of subnet names and their CIDR blocks |
