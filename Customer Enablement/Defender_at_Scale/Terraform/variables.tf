variable "mgmt_group_name" {
  type        = string
  description = "Specifies the name or UUID of this Management Group."
  default     = "testing_manage_group" // Change this to your management group ID
}

variable "location" {
  type        = string
  description = "Specifies the Azure location where the Resource Group should exist."
  default     = "eastus" // Change this to your location
}

