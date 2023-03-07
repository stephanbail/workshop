variable "rg-hub" {
  default     = "rg-hub-we-gw-d-01"
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "rg-gw" {
  default     = "rg-hub-we-gw-t-01"
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "rg-sha" {
  default     = "rg-sha-we-com-d-01"
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "location" {
  default     = "westeurope"
  type        = string
  description = "The Azure location where all resources in this example should be created."
}

variable "tags" {
  default = {
    Kundennummer = "itsc"
  }
  type        = map(string)
  description = "A mapping of tags to assign to the resources."
}

variable "tagstest" {
  default = {
    Kundennummer = "itsc"
    Funktion     = "Test"
  }
  type        = map(string)
  description = "A mapping of tags to assign to the resources."
}

variable "vnet_hub_name" {
  default     = "vnet-hub-we-gw-d-01"
  type        = string
  description = "The name of the virtual network."
}

variable "address_space" {
  default     = ["10.82.0.0/24"]
  type        = list(string)
  description = "The address space that is used by the virtual network (hub)."
}
