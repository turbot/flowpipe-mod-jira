
pipeline "get_issue_status" {
  title       = "Get an issue status"
  description = "Retrieve issue status."

  param "api_base_url" {
    type        = string
    description = "API base url."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "API access token."
    default     = var.token
    # TODO: Add once supported
    # sensitive  = true
  }

  param "user_email" {
    type        = string
    description = "The email-id of the Jira user."
    default     = var.user_email
  }

  # Here we can pass issue ID as well as issue KEY
  param "issue_id" {
    description = "Issue ID."
    type        = string
  }

  step "http" "get_issue_status" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}?fields=status"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

  }

  output "issue" {
    description = "Details about the issue."
    value       = step.http.get_issue_status.response_body
  }
}
