
/*
## CSPM ENABLEMENT
resource "azapi_update_resource" "setting_cspm" {
  type      = "Microsoft.Security/pricings@2022-03-01"
  name      = "CloudPosture"
  parent_id = "/providers/Microsoft.Management/managementGroups/${var.mgmt_group_name}"
  body = jsonencode({
    properties = {
      pricingTier = "Standard"
      extensions = [
        {
          name      = "SensitiveDataDiscovery"
          isEnabled = "True"
        },
        {
          name      = "ContainerRegistriesVulnerabilityAssessments"
          isEnabled = "True"
        },
        {
          name      = "AgentlessDiscoveryForKubernetes"
          isEnabled = "True"
        },
        {
          name      = "AgentlesssScanningForMachines"
          isEnabled = "True"
        }
      ]
    }
  })
}
*/

/*
## Auto Provision LAW

resource "azurerm_security_center_auto_provisioning" "auto-provisioning" {
  auto_provision = "On"
}
resource "azurerm_security_center_workspace" "auto_sc_workspace" {
  scope        = data.azurerm_management_group.example.id
  workspace_id = "/subscriptions/<subscription id>/resourcegroups/<resource group name>/providers/microsoft.operationalinsights/workspaces/<workspace name>"
}
*/

/*
resource "azurerm_security_center_workspace" "sc_workspace" {
  scope        = data.azurerm_management_group.example.id
  workspace_id = azurerm_log_analytics_workspace.la_workspace.id
}
*/