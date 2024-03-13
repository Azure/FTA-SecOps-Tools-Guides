#Enable Defender for Cloud on the Subscription

resource "azurerm_management_group_policy_assignment" "enableASC_assignment" {
 name                 = "enableASC_assignment"
 display_name         = "Enable Microsoft Defender for Cloud on your subscription"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ac076320-ddcf-4066-b451-6154267e8ad2"
 management_group_id  = data.azurerm_management_group.example.id
  location = var.location
  identity {
    type = "SystemAssigned"
  }
}

#Enable MCSB policy for Secure Score
resource "azurerm_management_group_policy_assignment" "mcsb_assignment" {
  name                 = "mcsb"
  display_name         = "Microsoft Cloud Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  management_group_id  = data.azurerm_management_group.example.id
location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for App Service

resource "azurerm_management_group_policy_assignment" "enableDfAppService" {
 name                 = "enableDfAppService"
 display_name         = "Configure Azure Defender for App Service to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b40e7bcd-a1e5-47fe-b9cf-2f534d0bfb7d"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for Key Vaults

resource "azurerm_management_group_policy_assignment" "enableDfKeyVaults" {
 name                 = "enableDfKeyVaults"
 display_name         = "Configure Azure Defender for Key Vaults to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1f725891-01c0-420a-9059-4fa46cb770b7"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for Storage with Malware scanning

resource "azurerm_management_group_policy_assignment" "enableDfStorageAccounts" {
 name                 = "enableDfStorageAccounts"
 display_name         = "Configure Microsoft Defender for Storage to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cfdc5972-75b3-4418-8ae1-7f5c36839390"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for Resource Manager 

resource "azurerm_management_group_policy_assignment" "enableDfResourceManager" {
 name                 = "enableDfResourceManager"
 display_name         = "Configure Azure Defender for Resource Manager to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b7021b2b-08fd-4dc0-9de7-3c6ece09faf9"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for Containers

resource "azurerm_management_group_policy_assignment" "enableDfContainers" {
 name                 = "enableDfContainers"
 display_name         = "Configure Microsoft Defender for Containers to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c9ddb292-b203-4738-aead-18e2716e858f"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


# Defender for Azure SQL Database

resource "azurerm_management_group_policy_assignment" "enableDfSQLDatabase" {
 name                 = "enableDfSQLDatabase"
 display_name         = "Configure Azure Defender for Azure SQL database to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b99b73e7-074b-4089-9395-b7236f094491"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


# Defender for Open-Source Relational Database

resource "azurerm_management_group_policy_assignment" "enableDfOpenSourceDatabase" {
 name                 = "enableDfOpenSourceDB"
 display_name         = "Configure Azure Defender for open-source relational databases to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/44433aa3-7ec2-4002-93ea-65c65ff0310a"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


# Defender for Cosmos DB

resource "azurerm_management_group_policy_assignment" "enableDfCosmosDatabase" {
 name                 = "enableDfCosmosDatabase"
 display_name         = "Configure Microsoft Defender for Azure Cosmos DB to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/82bf5b87-728b-4a74-ba4d-6123845cf542"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}






# Seperate file for IAAS Policy deploy

#Defender for Servers all P2

resource "azurerm_management_group_policy_assignment" "enableDfServers" {
 name                 = "enableDfServers"
 display_name         = "Configure Azure Defender for servers to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/8e86a5b6-b9bd-49d1-8e21-4bb8a0862222"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Defender for Servers to be enabled ('P1' subplan) for resoruces (resource level) with the selected tag

resource "azurerm_management_group_policy_assignment" "enableDfServersP1" {
 name                 = "enableDfServersP1"
 display_name         = "Configure Azure Defender for Servers to be enabled ('P1' subplan) for all resources (resource level) with the selected tag"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9e4879d9-c2a0-4e40-8017-1a5a5327c843"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
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

#Defender for Kubernetes Defender profile

resource "azurerm_management_group_policy_assignment" "enableDfKubernetesProfile" {
 name                 = "enableDfK8SProfile"
 display_name         = "Configure Azure Kubernetes Service clusters to enable Defender profile"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/64def556-fbad-4622-930e-72d1d5589bf5"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


# Defender for SQL Servers

resource "azurerm_management_group_policy_assignment" "enableDfSQLServers" {
 name                 = "enableDfSQLServers"
 display_name         = "Configure Azure Defender for SQL servers on machines to be enabled"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/50ea7265-7d8c-429e-9a7d-ca1f410191c3"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Auto install Defender for SQL on VMs

resource "azurerm_management_group_policy_assignment" "enableDfSQLServersAgent" {
 name                 = "enableDfSQLServersAgent"
 display_name         = "Configure SQL Virtual Machines to automatically install Microsoft Defender for SQL"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ddca0ddc-4e9d-4bbb-92a1-f7c4dd7ef7ce"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}


#Auto install Defender for SQL on ARC servers

resource "azurerm_management_group_policy_assignment" "enableDfSQLServersArcAgent" {
 name                 = "enableDfSQLArcAgent"
 display_name         = "Configure Arc-enabled SQL Servers to automatically install Microsoft Defender for SQL"
 policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/65503269-6a54-4553-8a28-0065a8e6d929"
 management_group_id  = data.azurerm_management_group.example.id
 location = var.location
  identity {
    type = "SystemAssigned"
  }
}




# Need to edit this data form to include all the policies so it goes and remediates them
/*

resource "azurerm_management_group" "example" {
  display_name = "Example Management Group"
}

data "azurerm_policy_definition" "example" {
  display_name = "Allowed locations"
}

resource "azurerm_management_group_policy_assignment" "example" {
  name                 = "exampleAssignment"
  management_group_id  = azurerm_management_group.example.id
  policy_definition_id = data.azurerm_policy_definition.example.id
  parameters = jsonencode({
    "listOfAllowedLocations" = {
      "value" = ["East US"]
    }
  })
}

resource "azurerm_management_group_policy_remediation" "example" {
  name                 = "example"
  management_group_id  = azurerm_management_group.example.id
  policy_assignment_id = azurerm_management_group_policy_assignment.example.id
}

*/


















/*
REMEDIATE POLICY
https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html

azurerm_policy_remediation : to create remediation tasks for the policy assignment.

COMPLIANCE

armclient post "/subscriptions/<subscriptionID>/providers/Microsoft.PolicyInsights/policyStates/latest/queryResults?api-version=2019-10-01&$filter=IsCompliant eq false and PolicyAssignmentId eq '<policyAssignmentID>'&$apply=groupby((ResourceId))" > <json file to direct the output with the resource IDs into>
*/