pipeline "get_issue_transitions" {
  title       = "Get Issue Transitions"
  description = "Returns either all transitions or a transition that can be performed by the user on a Jira issue"

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
