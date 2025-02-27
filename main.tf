terraform {
  backend "azurerm" {
    resource_group_name  = "policy-terraformstate-ports-001"
    storage_account_name = "policyterraports002"
    container_name       = "terraformstate"
    key                  = "terraform.region.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "policy_file" {
  description = "Path to the policy JSON file"
  default     = "./policies/deny_locations.json"
}

data "local_file" "deny_locations_policy" {
  filename = var.policy_file
}

resource "azurerm_policy_definition" "deny_locations" {
  name         = "deny-locations-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Specific Azure Locations"

  policy_rule = data.local_file.deny_locations_policy.content
}


resource "azurerm_subscription_policy_assignment" "location_policy" {
  name                 = "deny-locations-assignment"
  policy_definition_id = azurerm_policy_definition.deny_locations.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
}
