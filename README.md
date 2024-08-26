```hcl
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
| <a name="input_subnet_sizes"></a> [subnet\_sizes](#input\_subnet\_sizes) | List of subnet sizes if names are to be generated | `list(number)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnet names to their desired mask sizes and netnum | <pre>map(object({<br>    mask_size = number<br>    netnum    = number<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_cidr"></a> [base\_cidr](#output\_base\_cidr) | The base CIDR given to the module for calculation |
| <a name="output_base_cidr_set"></a> [base\_cidr\_set](#output\_base\_cidr\_set) | The base CIDR given to the module for calculation as a set |
| <a name="output_subnet_first_ip"></a> [subnet\_first\_ip](#output\_subnet\_first\_ip) | A map of subnet names to their first usable IP addresses. |
| <a name="output_subnet_first_last_ip"></a> [subnet\_first\_last\_ip](#output\_subnet\_first\_last\_ip) | A map of subnet names to their last usable IP addresses. |
| <a name="output_subnet_last_ip"></a> [subnet\_last\_ip](#output\_subnet\_last\_ip) | A map of subnet names to their first and last usable IP addresses. |
| <a name="output_subnet_mask_sizes"></a> [subnet\_mask\_sizes](#output\_subnet\_mask\_sizes) | A map of subnet names to their mask sizes. |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | A sorted list of subnet names calculated based on the provided details or sizes. |
| <a name="output_subnet_ranges"></a> [subnet\_ranges](#output\_subnet\_ranges) | A list of subnet CIDR ranges corresponding to the sorted subnet names, ensuring consistent ordering. |
| <a name="output_subnet_sizes"></a> [subnet\_sizes](#output\_subnet\_sizes) | A map of subnet names to the count of usable IPs in each subnet. |
| <a name="output_subnets_map"></a> [subnets\_map](#output\_subnets\_map) | A map of subnet names to their corresponding generated subnet CIDR ranges. |
