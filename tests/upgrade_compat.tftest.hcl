mock_provider "azurerm" {}

variables {
  resource_groups   = { rg-test = { name = "rg-test", location = "canadacentral" } }
  subnets           = { MAZ = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/MAZ" } }
  location          = "canadacentral"
  env               = "Dev"
  userDefinedString = "lb"
}

# Step 1: simulate the currently-deployed resource (pre-upgrade caller shape —
# no azurerm v5 renamed attributes are referenced directly by callers, they
# still pass the legacy `enable_floating_ip` / `enable_tcp_reset` keys).
# NOTE: command = plan, not apply — azurerm v5 strictly validates the ARM ID
# format of loadbalancer_id/probe_id references at apply time, and
# mock_provider's synthetic computed ids (e.g. "8iqpd9gw") fail that
# validation. plan-only still catches address/replacement changes.
run "baseline_plan" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "01"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
      probes = {
        tcp443 = {
          protocol = "Tcp"
          port     = 443
        }
      }
      rules = {
        tcp443 = {
          frontend_ip_configuration_name = "feipc1"
          protocol                       = "Tcp"
          frontend_port                  = 443
          backend_port                   = 443
          probe_name                     = "tcp443"
          enable_floating_ip             = true
          enable_tcp_reset               = true
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.name == "Dev-lb01-lb"
    error_message = "Baseline plan: unexpected Load Balancer name"
  }
}

# Step 2: plan the upgraded (azurerm v5) code against that same state with the
# same caller inputs — must show no replacement of any resource.
run "upgrade_plan_no_replacement" {
  command = plan

  variables {
    load_balancer = {
      resource_group_name = "rg-test"
      postfix             = "01"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                        = "MAZ"
          private_ip_address_allocation = "Dynamic"
        }
      }
      probes = {
        tcp443 = {
          protocol = "Tcp"
          port     = 443
        }
      }
      rules = {
        tcp443 = {
          frontend_ip_configuration_name = "feipc1"
          protocol                       = "Tcp"
          frontend_port                  = 443
          backend_port                   = 443
          probe_name                     = "tcp443"
          enable_floating_ip             = true
          enable_tcp_reset               = true
        }
      }
    }
  }

  assert {
    condition     = azurerm_lb.loadbalancer.name == "Dev-lb01-lb"
    error_message = "Resource name must be unchanged after upgrade"
  }

  assert {
    condition     = azurerm_lb_rule.loadbalancer-lbr["tcp443"].floating_ip_enabled == true
    error_message = "floating_ip_enabled must be derived from the same enable_floating_ip caller key, no tfvars change required"
  }
}
