################################
############ Common ############
################################

variable "stage" {
  description = "(Required) The environment."
  type        = string
  default     = "demo"
}

variable "project" {
  description = "(Required) The prefix for the resources created on Azure."
  type        = string
  default     = "cilium"
}

# resource location
variable "location" {
  description = "The location used for all resources."
  type        = string
  default     = "northeurope"

}
