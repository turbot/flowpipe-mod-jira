pipeline "add_comment" {
  title       = "Adds a comment to an issue"
  description = "Adds a comment to an issue."

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
    type        = string
    description = local.issue_id_param_description
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
