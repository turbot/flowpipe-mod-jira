
variable "jira_token" {
  type        = string
  description = "The Jira API token"
  default     = "anVkZWxsQHR1cmJvdC5jb206QVRBVFQzeEZmR0YwdTdUXy1aY2FQamVrQlZpQVVTMlpSNm1fSDRuUGt1VFlRcXFPcWJUejhOSGJ2ek8tZmlMQ1lHWTE3OWZzMTYzdDJoQXJ2SlBjcXlMYi1YRFRJNWkydVJtTzJlTzBSbHhQUllHQ0xyVk9rWWJRWVJNWGZPdHY4bWdLRzFTWEpyTHM4NzVUT3Z3MjVRcUdjajNFUDh1bktMajd1OXZaZDdnVTlFNkp5c2pPX1ZJPTUxQjREMkND5"
}

variable "base" {
  type = string
  default = "https://judell2.atlassian.net"
}

variable "project" {
  type = string
  default = "LW"
}
