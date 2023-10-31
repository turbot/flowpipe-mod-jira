variable "token" {
  type        = string
  description = "Jira API token"
}

variable "user_email"{
  type = string
  description = "The user's email"
}

variable "api_base_url" {
  type = string
  description = "Jira API base URL."
}

variable "project_key" {
  type = string
  description = "Jira project key."
}
