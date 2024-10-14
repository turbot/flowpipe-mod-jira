pipeline "add_comment" {
  title       = "Adds Comment"
  description = "Adds a comment to an issue."

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
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
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}/comment"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
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
