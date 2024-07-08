# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = ["10.0.0.0/16", ]
            location                     = "norwayeast"
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets = [
              {
                name             = "${local.root_id}-${local.region_alias}-prd-mgmt-hub-subnet"
                address_prefixes = ["10.0.0.0/20", ]
              },
              {
                name             = "${local.root_id}-${local.region_alias}-dev-mgmt-hub-subnet"
                address_prefixes = ["10.0.16.0/20",]
              },
              {
                name             = "${local.root_id}-${local.region_alias}-mgmt-dns-hub-subnet"
                address_prefixes = ["10.0.32.0/24", ]
              },
              {
                name             = "${local.root_id}-${local.region_alias}-alz-hub-subnet"
                address_prefixes = ["10.0.128.0/20",]
              },
            ]
            virtual_network_gateway = {
              enabled = false
              config = {
                address_prefix           = "10.0.1./24"
                gateway_sku_expressroute = "ErGw2AZ"
                gateway_sku_vpn          = ""
                advanced_vpn_settings = {
                  enable_bgp                       = null
                  active_active                    = null
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration         = []
                  bgp_settings                     = []
                  custom_route                     = []
                }
              }
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix                = "10.100.0.0/24"
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = {}
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
            enable_hub_network_mesh_peering         = false
          }
        },
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = false
        config = {
          location = "norwayeast"
        }
      }
      dns = {
        enabled = true
        config = {
          location = "norwayeast"
          enable_private_link_by_service = {
            azure_api_management                 = false
            azure_app_configuration_stores       = false
            azure_arc                            = false
            azure_automation_dscandhybridworker  = false
            azure_automation_webhook             = false
            azure_backup                         = false
            azure_batch_account                  = false
            azure_bot_service_bot                = false
            azure_bot_service_token              = false
            azure_cache_for_redis                = false
            azure_cache_for_redis_enterprise     = false
            azure_container_registry             = false
            azure_cosmos_db_cassandra            = false
            azure_cosmos_db_gremlin              = false
            azure_cosmos_db_mongodb              = false
            azure_cosmos_db_sql                  = false
            azure_cosmos_db_table                = false
            azure_data_explorer                  = false
            azure_data_factory                   = false
            azure_data_factory_portal            = false
            azure_data_health_data_services      = false
            azure_data_lake_file_system_gen2     = false
            azure_database_for_mariadb_server    = false
            azure_database_for_mysql_server      = false
            azure_database_for_postgresql_server = false
            azure_digital_twins                  = false
            azure_event_grid_domain              = false
            azure_event_grid_topic               = false
            azure_event_hubs_namespace           = false
            azure_file_sync                      = false
            azure_hdinsights                     = false
            azure_iot_dps                        = false
            azure_iot_hub                        = false
            azure_key_vault                      = false
            azure_key_vault_managed_hsm          = false
            azure_kubernetes_service_management  = false
            azure_machine_learning_workspace     = false
            azure_managed_disks                  = false
            azure_media_services                 = false
            azure_migrate                        = false
            azure_monitor                        = false
            azure_purview_account                = false
            azure_purview_studio                 = false
            azure_relay_namespace                = false
            azure_search_service                 = false
            azure_service_bus_namespace          = false
            azure_site_recovery                  = false
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_dev          = false
            azure_synapse_analytics_sql          = false
            azure_synapse_studio                 = false
            azure_web_apps_sites                 = false
            azure_web_apps_static_sites          = false
            cognitive_services_account           = false
            microsoft_power_bi                   = false
            signalr                              = false
            signalr_webpubsub                    = false
            storage_account_blob                 = false
            storage_account_file                 = false
            storage_account_queue                = false
            storage_account_table                = false
            storage_account_web                  = false
          }
          private_link_locations = [
            "norwayeast",
          ]
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }

    location = local.connectivity_resources_location
    tags     = local.connectivity_resources_tags
    advanced = { # override setting of networking
      custom_settings_by_resource_type = {
        azurerm_resource_group = {
          connectivity = {
            norwayeast = { # replace with the location you're using
              name = "${local.root_id}-${local.region_alias}-connectivity-rg"
            }
          },
          ddos = {
            norwayeast = { # replace with the location you're using
              name = "${local.root_id}-${local.region_alias}-ddos-rg"
            }
          },
          dns = {
            norwayeast = { # replace with the location you're using
              name = "${local.root_id}-${local.region_alias}-dns-rg"
            }
          }
        },
        azurerm_virtual_network = { # To change the name of hub vnet
          connectivity = {
            norwayeast = { # replace with the location you're using
              name = "${local.root_id}-${local.region_alias}-hub-vnet"
            }
          }
        },
        # azurerm_subnet = { # Subnet delegation for dns resolver
        #   connectivity = {
        #     norwayeast = {                   # replace with the location you're using
        #       cd-${local.region_alias}-mgmt-dns-hub-subnet = { # replace with the name of subnet you are using
        #         delegation = [
        #           {
        #             name = "Microsoft.Network/dnsResolvers"
        #             service_delegation = [
        #               {
        #                 actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        #                 name    = "Microsoft.Network/dnsResolvers"
        #               }
        #             ]
        #           }
        #         ]
        #       }
        #     }
        #   }
        # }
      }
    }

  }
}