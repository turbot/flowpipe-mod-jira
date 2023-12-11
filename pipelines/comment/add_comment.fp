pipeline "add_comment" {
  title       = "Adds Comment to Issue"
  description = "Adds a comment to an issue."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_id}/comment"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
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
