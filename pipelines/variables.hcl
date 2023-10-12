variable "token" {
  type        = string
  description = "The Jira API token"
  default     = ""
}

variable "user_email"{
  type = string
  description = "The user's email"
  default = ""
}

variable "subdomain" {
  type = string
  default = ""
}

variable "project_key" {
  type = string
  default = ""
}
