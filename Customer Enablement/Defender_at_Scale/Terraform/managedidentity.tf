# Create a system-assigned managed identity
resource "azurerm_user_assigned_identity" "MDCAtScale" {
  name                = "DefenderforCloudAtScale"
  location            = "EastUs"  # Replace with your desired location
  resource_group_name = "testing"
}

resource "azurerm_role_assignment" "owner_assignment" {
  principal_id          = azurerm_user_assigned_identity.MDCAtScale.principal_id
  role_definition_name  = "Owner"
  scope                = "/providers/Microsoft.Management/managementGroups/Production"
}

resource "azurerm_role_assignment" "security_admin_assignment" {
  principal_id          = azurerm_user_assigned_identity.MDCAtScale.principal_id
  role_definition_name  = "Security Admin"
  scope                = "/providers/Microsoft.Management/managementGroups/Production"
}
