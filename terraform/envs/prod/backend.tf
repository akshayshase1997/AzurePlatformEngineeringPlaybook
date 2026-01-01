terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateakshay001"
    container_name       = "tfstate"
    key                  = "platform/prod/terraform.tfstate"
    subscription_id      = "5e40c3da-c53a-453c-b8a8-3e5350aabad8"
    use_azuread_auth = true
  }
}
