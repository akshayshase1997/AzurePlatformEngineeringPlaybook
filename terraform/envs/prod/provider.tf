provider "azurerm" {
  features {}
  
  # Authentication is handled via environment variables:
  # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID
  # The provider automatically reads these if not specified here.
  # See .env.example for required variables.
  
  resource_provider_registrations = "none"
}
