variable "mgmt_group_name" {
  type        = string
  description = "Specifies the name or UUID of this Management Group."
  default     = "Production" // Change this to your management group ID
}

variable "location" {
  type        = string
  description = "Specifies the Azure location where the Resource Group should exist."
  default     = "eastus" // Change this to your location
}

variable "scope" {
  type = string
  description = "Specifies the scope of application of policy and remediation"
  default = "/managementGroups/Production" //Change this to your desired scope
}

//variable "log_analytics_workspace_id" {
  //description = "ID of the Log Analytics workspace"
//}