variable "subscription_id" {
  type        = string
  description = "Specifies the name or UUID of the Subscription."
  default = "/subscriptions/adeb6b55-d404-465f-884c-a232d0135aad"
}

variable "resource_group_name" {
  type        = string
  description = "Specifies the name of this Resource Group."
  default = "testing"
}

variable "location" {
  type        = string
  description = "Specifies the Azure location where the Resource Group should exist."
  default = "eastus"
}

variable "log_azurerm_log_analytics_workspace" {
  type = string
  description = "defines the centralized log analytics workspace for security events"
  default = "/subscriptions/[yoursubscriptionID]/resourceGroups/[yourResourceGroupName]/providers/Microsoft.OperationalInsights/workspaces/[yourWorkspaceName]"
  
}

variable "email" {
  type = string
  description = "Email of the Contact for Security Alerts in Defender for Cloud"
  default = "email@yourdomain.com"
}
variable "phonenumber" {
  type = string
  description = "Phone Contact for Security alerts"
  default = "123456789"
  
}