resource "azurerm_resource_group" "this" {
  name     = "rg-platform-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
