# terraform-azurerm-caf-load_balancer

Terraform module to deploy an Azure Load Balancer (`azurerm_lb`) along with its
health probes, backend address pool, and load balancing rules, following the
SSC CAF naming convention. Requires the `azurerm` provider `~> 5.0`.

## New optional arguments (name overrides)

Every auto-generated resource name accepts an optional caller-supplied override so
existing deployments whose real names diverge from the naming formula can be
managed without a destroy/recreate:

| Location | Key | Default when omitted |
|---|---|---|
| `load_balancer.frontend_ip_configuration.<key>` | `name` | `<lb-name>-<key>-lbfe` |
| `load_balancer` | `backend_address_pool_name` | `<lb-name>-HA-lbbp` |
| `load_balancer.probes.<key>` | `name` | `<lb-name>-<key>-lbhp` |
| `load_balancer.rules.<key>` | `name` | `<lb-name>-<key>-lbr` |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.0.0 |

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
| <a name="input_env"></a> [env](#input\_env) | (Required) 4 character string defining the environment name prefix for the Load Balancer | `string` | n/a | yes |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Details about load balancer | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the Load Balancer | `string` | `"canadacentral"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object for the Load Balancer | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) List of subnet objects for the Load Balancer | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to every associated Load Balancer resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) User defined portion value for the name of the Load Balancer. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loadbalancer"></a> [loadbalancer](#output\_loadbalancer) | Load Balancer object |
| <a name="output_loadbalancer_backend_address_pool"></a> [loadbalancer\_backend\_address\_pool](#output\_loadbalancer\_backend\_address\_pool) | Load Balancer backend address pool object |
| <a name="output_loadbalancer_backend_rule"></a> [loadbalancer\_backend\_rule](#output\_loadbalancer\_backend\_rule) | Load Balancer backend rule object |
| <a name="output_loadbalancer_health_probe"></a> [loadbalancer\_health\_probe](#output\_loadbalancer\_health\_probe) | Load Balancer  health probe object |
<!-- END_TF_DOCS -->
