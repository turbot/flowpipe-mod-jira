variable "token" {
  type        = string
  description = "The Jira API token"
  default     = "ATATT3xFfGF0u7T_-ZcaPjekBViAUS2ZR6m_H4nPkuTYQqqOqbTz8NHbvzO-fiLCYGY179fs163t2hArvJPcqyLb-XDTI5i2uRmO2eO0RlxPRYGCLrVOkYbQYRMXfOtv8mgKG1SXJrLs875TOvw25QqGcj3EP8unKLj7u9vZd7gU9E6JysjO_VI=51B4D2CC"
}

variable "user_email"{
  type = string
  description = "The user's email"
  default = "judell@turbot.com"
}

variable "subdomain" {
  type = string
  default = "judell2" # just ask subdomain, and create a local
}

variable "project_key" {
  type = string
  default = "LW"
}
