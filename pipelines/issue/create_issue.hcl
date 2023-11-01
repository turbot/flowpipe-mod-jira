pipeline "create_issue" {
  title       = "Create an Issue"
  description = "Create a new issue."

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
    description = "The key identifying the project."
    default     = var.project_key
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
  }

  param "summary" {
    type        = string
    description = "Issue summary."
  }

  param "description" {
    type        = string
    description = "Issue description."
  }

  step "http" "create_issue" {
    method = "post"
    url    = "${param.api_base_url}/rest/api/2/issue"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

    request_body = jsonencode({
      fields = {
        project = {
          key = param.project_key
        },
        summary     = param.summary,
        description = param.description,
        issuetype = {
          name = param.issue_type
        }
      }
    })
  }

  output "issue" {
    description = "Issue metadata."
    value       = step.http.create_issue.response_body
  }
}