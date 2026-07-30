variable "location" {
  description = "Azure location for the Load Balancer"
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags that will be applied to every associated Load Balancer resource"
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "(Required) 4 character string defining the environment name prefix for the Load Balancer"
  type        = string
}

variable "userDefinedString" {
  description = "(Required) User defined portion value for the name of the Load Balancer."
  type        = string
}

variable "load_balancer" {
  description = "Details about load balancer"
  type        = any
  default     = {}
}

variable "resource_groups" {
  description = "(Required) Resource group object for the Load Balancer"
  type        = any
  default     = {}
}

variable "subnets" {
  description = "(Required) List of subnet objects for the Load Balancer"
  type        = any
}
