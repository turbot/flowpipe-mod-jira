variable "token" {
  type        = string
  description = "Jira API access token."
}

variable "user_email" {
  type        = string
  description = "Email-id of the Jira user."
}

variable "api_base_url" {
  type        = string
  description = "Jira API base URL."
}

variable "project_key" {
  type        = string
  description = "The key identifying the Jira project."
}
