variable "tenant_id" {
  type        = string
  description = "ID of the azure tenant"
  default     = ""
}

variable "customer_subscription_id" {
  type        = string
  description = "ID of the customer azure subscription"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure location where all resources in this example should be created."
}

variable "avd-resource-group" {
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "avd_numeric_suffix" {
  type        = string
  description = "The numeric suffix of the resource group in which to create the resources."
}

variable "subnet_id" {
  type        = string
  description = "The subnet id of the resource group in which to create the resources."
}

variable "azure_managed_disk_id" {
  default     = ""
  type        = string
  description = ""
}
