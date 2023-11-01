pipeline "add_comment" {
  title       = "Add comment to the Issue"
  description = "Add comment to the issue."

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
    description = "The email-id of the Jira user."
    default     = var.user_email
  }

  param "issue_id" {
    type        = string
    description = "Issue ID."
  }

  param "comment_text" {
    type        = string
    description = "Issue comment."
  }

  step "http" "add_comment" {
    method = "post"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}/comment"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

    request_body = jsonencode({
      body = param.comment_text
    })
  }

  output "status" {
    description = "Details about the issue comment."
    value       = step.http.add_comment.response_body
  }
}