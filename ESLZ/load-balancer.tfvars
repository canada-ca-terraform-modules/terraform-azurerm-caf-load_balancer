load_balancers = {
    lb = {
      #
      # azurerm_lb section
      #
      # edge_zone = "" # (Optional) Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Changing this forces a new Load Balancer to be created.
      resource_group_name ="Project"
      postfix = "01"
      frontend_ip_configuration = {
        feipc1 = {
          subnet                                             = "MAZ"         # (Required) The name or the resource id of the Subnet which should be used for this IP Configuration
          # private_ip_address                                 = "10.10.10.10" # (Optional) Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned.
          private_ip_address_allocation                      = "Dynamic"     # (Optional) The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static.
          # private_ip_address_version                         = "IPv4"        # (Optional) The version of IP that the Private IP Address is. Possible values are IPv4 or IPv6.
          # public_ip_address_id                               = ""            # (Optional) The ID of a Public IP Address which should be associated with the Load Balancer.
          # public_ip_prefix_id                                = ""            # (Optional) The ID of a Public IP Prefix which should be associated with the Load Balancer. Public IP Prefix can only be used with outbound rules.
          # zones                                              = [""]          # (Optional) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located.
          # gateway_load_balancer_frontend_ip_configuration_id = ""            # (Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer.
          # tags = {
          #   some = "a"
          #   new  = "b"
          #   tag  = "c"
          # }
        }
      }

      # sku      = "Standard" # Optional. Default to Standard
      # sku_tier = "Regional" # (Optional) sku_tier - (Optional) The SKU tier of this Load Balancer. Possible values are Global and Regional. Defaults to Regional. Changing this forces a new resource to be created.

      #
      # azurerm_lb_backend_address_pool section
      #
      # synchronous_mode = "Automatic" # (Optional) The backend address synchronous mode for the Backend Address Pool. Possible values are Automatic and Manual. This is required with virtual_network_id. Changing this forces a new resource to be created.
      # tunnel_interface = {
      #   ti1 = {
      #     identifier = ""     # (Required) The unique identifier of this Gateway Load Balancer Tunnel Interface.
      #     type       = "None" # (Required) The traffic type of this Gateway Load Balancer Tunnel Interface. Possible values are None, Internal and External.
      #     protocol   = "None" # (Required) The protocol used for this Gateway Load Balancer Tunnel Interface. Possible values are None, Native and VXLAN.
      #     port       = 2345   # (Required) The port number that this Gateway Load Balancer Tunnel Interface listens to.
      #   }
      # }
      # virtual_network_id = "" # (Optional) The ID of the Virtual Network within which the Backend Address Pool should exist.

      #
      # azurerm_lb_probe section
      #
      probes = {
        tcp443 = {
          protocol        = "Tcp" # (Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If TCP is specified, a received ACK is required for the probe to be successful. If HTTP is specified, a 200 OK response from the specified URI is required for the probe to be successful. Defaults to Tcp.
          port            = 443   # (Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.
          probe_threshold = 1     # (Optional) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100. The default value is 1.
          # request_path        = ""    # (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed.
          # interval_in_seconds = 15    # (Optional) The interval, in seconds between probes to the backend endpoint for health status. The default value is 15, the minimum value is 5.
        }
        tcp80 = {
          protocol        = "Tcp" # (Optional) Specifies the protocol of the end point. Possible values are Http, Https or Tcp. If TCP is specified, a received ACK is required for the probe to be successful. If HTTP is specified, a 200 OK response from the specified URI is required for the probe to be successful. Defaults to Tcp.
          port            = 80    # (Required) Port on which the Probe queries the backend endpoint. Possible values range from 1 to 65535, inclusive.
          probe_threshold = 1     # (Optional) The number of consecutive successful or failed probes that allow or deny traffic to this endpoint. Possible values range from 1 to 100. The default value is 1.
          # request_path        = ""    # (Optional) The URI used for requesting health status from the backend endpoint. Required if protocol is set to Http or Https. Otherwise, it is not allowed.
          # interval_in_seconds = 15    # (Optional) The interval, in seconds between probes to the backend endpoint for health status. The default value is 15, the minimum value is 5.
        }
      }

      #
      # azurerm_lb_rule section
      #
      rules = {
        tcp443 = {
          protocol                       = "Tcp"    # (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All.
          frontend_port                  = 443      # (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive. A port of 0 means "Any Port".
          backend_port                   = 443      # (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive. A port of 0 means "Any Port".
          probe_name                     = "tcp443" # (Optional) The name of a Probe defined above
          enable_floating_ip             = true     # (Optional) Are the Floating IPs enabled for this Load Balancer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false.
          frontend_ip_configuration_name = "feipc1" # (Requires) The name of the Frontend IP Configuration to associate with the Load Balancer Rule.
          # idle_timeout_in_minutes        = 4                  # (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 100 minutes. Defaults to 4 minutes.
          load_distribution = "SourceIPProtocol" #(Optional) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where in the Azure portal the options are called None, Client IP and Client IP and Protocol respectively. Defaults to Default.
          # disable_outbound_snat          = false              # (Optional) Should outbound SNAT be disabled for this Load Balancer Rule? Defaults to false.
          # enable_tcp_reset               = true               # (Optional) Is TCP Reset enabled for this Load Balancer Rule
        },
        tcp80 = {
          protocol                       = "Tcp"    # (Required) The transport protocol for the external endpoint. Possible values are Tcp, Udp or All.
          frontend_port                  = 80       # (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive. A port of 0 means "Any Port".
          backend_port                   = 80       # (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive. A port of 0 means "Any Port".
          probe_name                     = "tcp80"  # (Optional) The name of a Probe defined above
          enable_floating_ip             = true     # (Optional) Are the Floating IPs enabled for this Load Balancer Rule? A "floating” IP is reassigned to a secondary server in case the primary server fails. Required to configure a SQL AlwaysOn Availability Group. Defaults to false.
          frontend_ip_configuration_name = "feipc1" # (Requires) The name of the Frontend IP Configuration to associate with the Load Balancer Rule.
          # idle_timeout_in_minutes        = 4                  # (Optional) Specifies the idle timeout in minutes for TCP connections. Valid values are between 4 and 100 minutes. Defaults to 4 minutes.
          load_distribution = "SourceIPProtocol" #(Optional) Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where in the Azure portal the options are called None, Client IP and Client IP and Protocol respectively. Defaults to Default.
          # disable_outbound_snat          = false              # (Optional) Should outbound SNAT be disabled for this Load Balancer Rule? Defaults to false.
          # enable_tcp_reset               = true               # (Optional) Is TCP Reset enabled for this Load Balancer Rule
        }
      }
    }

                                     # (Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located. Changing this forces a new Linux Virtual Machine Scale Set to be created.
}

