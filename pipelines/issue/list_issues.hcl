pipeline "list_issues" {
  title       = "List Issues"
  description = "List of issues in a Jira project."

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
    description = "Email-id of the user."
    default     = var.user_email
  }

  param "project_key" {
    type        = string
    description = "The key of the project."
    default     = var.project_key
  }

  step "http" "list_issues" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/2/search?jql=project=${param.project_key}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

  }

  output "issues" {
    description = "List of issues."
    value       = step.http.list_issues.response_body
  }

}