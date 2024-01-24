resource "azurerm_resource_group" "security_rg" {
  name     = var.resource_group_name
  location = var.location
}

## Allows you to create LAW and onboard

/*
resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = "mdc-security-workspace"
  location            = azurerm_resource_group.security_rg.location
  resource_group_name = azurerm_resource_group.security_rg.name
  sku                 = "PerGB2018"
}
*/
