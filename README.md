<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lb.loadbalancer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.loadbalancer-lbbp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.loadbalancer-lbhp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.loadbalancer-lbr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) 4 character string defining the environment name prefix for the VM | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Character string defining the group for the target subscription | `string` | n/a | yes |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Details about load balancer | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the VM | `string` | `"canadacentral"` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Character string defining the project for the target subscription | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object for the VM | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) List of subnet objects for the VM | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to every associated VM resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) User defined portion value for the name of the VM. | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | (Optional) The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer"></a> [loadbalancer](#output\_loadbalancer) | Load Balancer object |
<!-- END_TF_DOCS -->