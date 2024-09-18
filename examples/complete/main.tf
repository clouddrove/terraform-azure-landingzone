locals {
  #root
root_id   = "cd"
root_name = "cd-mg"
region_alias = "noe"
#connectivity_resources
deploy_connectivity_resources   = true
connectivity_resources_location = "norwayeast"
connectivity_resources_tags = {
  org = "clouddrove"
}
}

data "azurerm_client_config" "core" {}


module "enterprise_scale" {
  # source = "clouddrove/landingzone/azure"
  source = "../../"
  # version = "5.0.3" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = "Norway East"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = local.root_id
  root_name      = local.root_name
  library_path   = "${path.root}/lib" #for custome landing zone provide a lib path.

  ##application custom management group
  custom_landing_zones = {
    "${local.root_id}-application-prd-mg" = {
      display_name               = "${(local.root_id)}-application-prd-mg"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "customer_online" #there are two archtype in landinz zone ( "customer_online", "corp")
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["eastus", ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["eastus", ]
          }
        }
        access_control = {}
      }
    }
    "${local.root_id}-application-stg-mg" = {
      display_name               = "${(local.root_id)}-application-stg-mg"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Resource-Locations = {
            listOfAllowedLocations = ["eastus", ]
          }
          Deny-RSG-Locations = {
            listOfAllowedLocations = ["eastus", ]
          }
        }
        access_control = {}
      }
    }
    "${local.root_id}-application-dev-mg" = {
      display_name               = "${(local.root_id)}-application-dev-mg"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = [] #subs id of application env
      archetype_config = {
        archetype_id = "customer_online"
        parameters = {
          Deny-Subnet-Without-Nsg = {
            effect = "Audit"
          }
        }
        access_control = {
          # Contributor                = [data.azurerm_client_config.core.object_id] #["user_object_id"]
          # "Key Vault Crypto Officer" = [data.azurerm_client_config.core.object_id]  #["user_object_id"]
          # "Owner"                    = [data.azurerm_client_config.core.object_id] #["user_object_id"]
        }
      }
    }
  }

  #Connectivity Resources
  deploy_connectivity_resources    = local.deploy_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.core.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  #override policy
  archetype_config_overrides = {
    landing-zones = {
      archetype_id = "es_landing_zones"
      parameters = {
        Deny-Subnet-Without-Nsg = {
          effect = "Audit"
        }
      }
      access_control = {}
    }
  }
}