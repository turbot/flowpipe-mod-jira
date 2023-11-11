pipeline "close_issue" {
  title       = "Close an Issue"
  description = "Close an issue in a project in Jira."

  param "api_base_url" {
    type        = string
    description = local.api_base_url_param_description
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = local.token_param_description
    default     = var.token
    # TODO: Add once supported
    # sensitive  = true
  }

  param "user_email" {
    type        = string
    description = local.user_email_param_description
    default     = var.user_email
  }

  param "issue_id" {
    description = "Issue ID."
    type        = string
  }

  param "transition_id" {
    description = "ID of the transition for closing the issue."
    type        = number
  }

  step "http" "close_issue" {
    method = "post"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    request_body = jsonencode({
      transition = {
        id = param.transition_id
      }
    })

    basic_auth {
      username = param.user_email
      password = param.token
    }
  }
}
