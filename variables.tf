# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = ""
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = ""
}
# organization Division
variable "organization" {
  description = "organization- Infrastructure belongs"
  type        = string
  default     = ""
}
# team Variable
variable "team" {
  description = "organization team for  Infrastructure belongs"
  type        = string
  default     = ""
}


# EKS OIDC ROOT CA Thumbprint, eks oidc root ca thumbprint
variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

