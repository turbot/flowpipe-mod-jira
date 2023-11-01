pipeline "delete_issue" {
  title       = "Delete an Issue"
  description = "Delete an issue"

  param "api_base_url" {
    type        = string
    description = "Jira API base url."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "Jira access token."
    default     = var.token
    # TODO: Add once supported
    # sensitive  = true
  }

  param "user_email" {
    type        = string
    description = "The email-id of the user."
    default     = var.user_email
  }

  param "issue_id" {
    description = "Issue ID."
    type        = number
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