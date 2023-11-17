pipeline "get_issue_transitions" {
  title       = "Get Issue Transitions"
  description = "Get available transitions for a Jira issue."

  param "api_base_url" {
    type        = string
    description = "Jira API base url."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "Jira API access token."
    default     = var.token
  }

  param "user_email" {
    type        = string
    description = "Email-id of the Jira user."
    default     = var.user_email
  }

  param "issue_key" {
    type        = string
    description = "Key of the Jira issue to get transitions for."
  }

  step "http" "get_issue_transitions" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_key}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }
  }

  output "transitions" {
    description = "Details about available transitions for the issue."
    value       = step.http.get_issue_transitions.response_body.transitions
  }
}
