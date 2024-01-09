## Current Management Group
data "azurerm_management_group" "example" {
  name = var.mgmt_group_name
}
resource "azurerm_resource_group" "security_rg" {
  name     = var.resource_group_name
  location = var.location
}

## Allows you to create LAW and onboard

resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = "mdc-security-workspace"
  location            = azurerm_resource_group.security_rg.location
  resource_group_name = azurerm_resource_group.security_rg.name
  sku                 = "PerGB2018"
}

/*
resource "azurerm_security_center_workspace" "sc_workspace" {
  scope        = data.azurerm_management_group.example.id
  workspace_id = azurerm_log_analytics_workspace.la_workspace.id
}
*/

## Policy Assignment

resource "azurerm_management_group_policy_assignment" "mcsb_assignment" {
  name                 = "mcsb"
  display_name         = "Microsoft Cloud Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  management_group_id  = data.azurerm_management_group.example.id
}

resource "azurerm_security_center_subscription_pricing" "mdc_arm" {
  tier          = "Standard"
  resource_type = "Arm"
  subplan       = "PerApiCall"
}

resource "azurerm_security_center_subscription_pricing" "mdc_servers" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P2"
}

resource "azurerm_security_center_subscription_pricing" "mdc_cspm" {
  tier          = "Standard"
  resource_type = "CloudPosture"
extension {
    name = "ContainerRegistriesVulnerabilityAssessments"
  }
 
  extension {
    name = "AgentlessVmScanning"
    additional_extension_properties = {
      ExclusionTags = "[]"
    }
  }
 
  extension {
    name = "AgentlessDiscoveryForKubernetes"
  }
 
  extension {
    name = "SensitiveDataDiscovery"
  }
}
resource "azurerm_security_center_subscription_pricing" "mdc_storage" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
  subplan       = "DefenderForStorageV2"
}

resource "azurerm_security_center_subscription_pricing" "mdc_appservices" {
   tier = "Standard"
   resource_type = "AppServices"
}

resource "azurerm_security_center_subscription_pricing" "mdc_containerregistry" {
   tier = "Standard"
   resource_type = "ContainerRegistry"
}
 
resource "azurerm_security_center_subscription_pricing" "mdc_keyvaults" {
   tier = "Standard"
   resource_type = "KeyVaults"
}
 
resource "azurerm_security_center_subscription_pricing" "mdc_kubernetesservice" {
   tier = "Standard"
   resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "mdc_sqlservers" {
   tier = "Standard"
   resource_type = "SqlServers"
}

resource "azurerm_security_center_setting" "setting_mde" {
  setting_name = "WDATP"
  enabled      = true
}

resource "azapi_resource" "setting_agentless_vm" {
  type      = "Microsoft.Security/vmScanners@2022-03-01-preview"
  name      = "default"
  parent_id = data.azurerm_management_group.example.id
  body = jsonencode({
    properties = {
      scanningMode = "Default"
    }
  })
  schema_validation_enabled = false
}

/*
## QUALYS ENABLEMENT

resource "azurerm_management_group_policy_assignment" "va-auto-provisioning" {
  name                 = "mdc-va-autoprovisioning"
  display_name         = "Configure machines to receive a vulnerability assessment provider"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b"
  management_group_id  = data.azurerm_management_group.example.id
  identity {
    type = "SystemAssigned"
  }
  location   = var.location
  parameters = <<PARAMS
{ "vaType": { "value": "default" } }
PARAMS
}

resource "azurerm_role_assignment" "va-auto-provisioning-identity-role" {
  scope              = data.azurerm_management_group.example.id
  role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
  principal_id       = azurerm_management_group_policy_assignment.va-auto-provisioning.identity[0].principal_id
}

## CSPM ENABLEMENT

resource "azapi_update_resource" "setting_cspm" {
  type      = "Microsoft.Security/pricings@2023-01-01"
  name      = "CloudPosture"
  parent_id = data.azurerm_management_group.example.id
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
        }
      ]
    }
  })
}



## Security Contacts

resource "azurerm_security_center_contact" "mdc_contact" {
  email               = "john.doe@contoso.com"
  phone               = "+351919191919"
  alert_notifications = true
  alerts_to_admins    = true
}

# Enable Vuln Man

resource "azapi_resource" "DfSMDVMSettings" {
  type      = "Microsoft.Security/serverVulnerabilityAssessmentsSettings@2022-01-01-preview"
  name      = "AzureServersSetting"
  parent_id = data.azurerm_management_group.example.id
  body = jsonencode({
    properties = {
      selectedProvider = "MdeTvm"
    }
    kind = "AzureServersSetting"
  })
  schema_validation_enabled = false
}

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
