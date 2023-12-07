pipeline "delete_issue" {
  title       = "Delete an Issue"
  description = "Delete an issue from a project in Jira.(Note:An issue cannot be deleted if it has one or more subtasks.)"

  tags = {
    type = "featured"
  }
  
  param "api_base_url" {
    type        = string
    description = local.api_base_url_param_description
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = local.token_param_description
    default     = var.token
  }

  param "user_email" {
    type        = string
    description = local.user_email_param_description
    default     = var.user_email
  }

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "delete_issue" {
    method = "delete"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }
  }
}