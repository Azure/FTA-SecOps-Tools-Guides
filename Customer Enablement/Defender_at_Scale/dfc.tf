## Policy Assignment

resource "azurerm_management_group_policy_assignment" "mcsb_assignment" {
  name                 = "mcsb"
  display_name         = "Microsoft Cloud Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  management_group_id  = data.azurerm_management_group.example.id
}

# Enable Vulnerability Assessment for Servers
resource "azurerm_management_group_policy_assignment" "va_assignment" {
  name                 = "vuln-assess-servers"
  display_name         = "Vulnerbility Assessment for Machines"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13ce0167-8ca6-4048-8e6b-f996402e3c1b"
  management_group_id  = data.azurerm_management_group.example.id
  location = var.location
  identity {
    type = "SystemAssigned"
  }
}

# Deploying Defender agent in Azure for Kubernetes
resource "azurerm_management_group_policy_assignment" "def_profile" {
  name =  "defender-profile"
  display_name = "Defender Profile"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5"
  management_group_id = data.azurerm_management_group.example.id
  location = var.location
  identity {
    type = "SystemAssigned"
  }
}

# Deploying Defender agent in Azure for Arc Kubernetes
resource "azurerm_management_group_policy_assignment" "arc_def_profile" {
  name =  "arc-defender-profile"
  display_name = "Arc Defender Profile"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/708b60a6-d253-4fe0-9114-4be4c00f012c"
  management_group_id = data.azurerm_management_group.example.id
  location = var.location
  identity {
    type = "SystemAssigned"
  }
}

## Turning on Defender for Cloud
resource "azurerm_security_center_subscription_pricing" "mdc_arm" {
  tier          = "Standard"
  resource_type = "Arm"
  subplan       = "PerApiCall"
}

resource "azurerm_security_center_subscription_pricing" "mdc_servers" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
  subplan       = "P2"
  extension {
    name = "AgentlessVMScanning"
  }
  extension {
    name = "MdeDesignatedSubscription"
  }
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
 
resource "azurerm_security_center_subscription_pricing" "mdc_sqlservers" {
   tier = "Standard"
   resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "mdc_OpenSourceRelationalDatabases" {
  tier          = "Standard"
  resource_type = "OpenSourceRelationalDatabases"
}

resource "azurerm_security_center_subscription_pricing" "mdc_Containers" {
  tier          = "Standard"
  resource_type = "Containers"
}

# Security Contacts
resource "azurerm_security_center_contact" "mdc_contact" {
  email               = "john.doe@contoso.com"
  phone               = "+12380183043"
  alert_notifications = true
  alerts_to_admins    = true
}

