variable "project_name" {
  description = "Short name for the project, used in resource naming (lowercase, hyphens ok)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,18}[a-z0-9]$", var.project_name))
    error_message = "project_name must be 3–20 lowercase alphanumeric characters or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Deployment environment: dev, test, staging, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, staging, prod."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "westeurope"
}

variable "owner" {
  description = "Owner email or team name, used in resource tags."
  type        = string
  default     = "platform-team"
}

variable "allowed_ip_ranges" {
  description = "List of IP address ranges allowed to access the Key Vault."
  type        = list(string)
  default     = []
}
