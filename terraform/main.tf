terraform {
  backend "azurerm" {
    resource_group_name  = "policy-terraformstate-ports-002"
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


data "local_file" "deny_locations_policy" {
  filename = "./policies/deny_locations.json"
}

resource "azurerm_policy_definition" "deny_locations" {
  name         = "deny-locations-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Specific Azure Locations"

  policy_rule = jsonencode({
    "if" = {
      "allOf" = [
        {
          "field" = "location"
          "notIn" = var.allowed_locations
        }
      ]
    }
    "then" = {
      "effect" = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "location_policy" {
  name                 = "deny-locations-assignment"
  policy_definition_id = azurerm_policy_definition.deny_locations.id
  subscription_id      = var.subscription_id
}