
variable "jira_token" {
  type        = string
  description = "The Jira API token"
  #default     = "anVkZWxsQHR1cmJvdC5jb206QVRBVFQzeEZmR0YwdTdUXy1aY2FQamVrQlZpQVVTMlpSNm1fSDRuUGt1VFlRcXFPcWJUejhOSGJ2ek8tZmlMQ1lHWTE3OWZzMTYzdDJoQXJ2SlBjcXlMYi1YRFRJNWkydVJtTzJlTzBSbHhQUllHQ0xyVk9rWWJRWVJNWGZPdHY4bWdLRzFTWEpyTHM4NzVUT3Z3MjVRcUdjajNFUDh1bktMajd1OXZaZDdnVTlFNkp5c2pPX1ZJPTUxQjREMkND5"
  default     = "ATATT3xFfGF0u7T_-ZcaPjekBViAUS2ZR6m_H4nPkuTYQqqOqbTz8NHbvzO-fiLCYGY179fs163t2hArvJPcqyLb-XDTI5i2uRmO2eO0RlxPRYGCLrVOkYbQYRMXfOtv8mgKG1SXJrLs875TOvw25QqGcj3EP8unKLj7u9vZd7gU9E6JysjO_VI=51B4D2CC"
}

variable "jira_user_email"{
  type = string
  description = "The user's email"
  default = "judell@turbot.com"
}

variable "jira_base" {
  type = string
  default = "https://judell2.atlassian.net"
}

variable "jira_project_key" {
  type = string
  default = "LW"
}
