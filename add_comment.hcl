pipeline "add_comment" {
  description = "Add a comment to a Jira issue."

  param "token" {
    type    = string
    default = var.token
  }

  param "issue_id" {
    type = string
  }

  param "comment_text" {
    type = string
  }

  step "http" "add_comment" {
    method = "post"
    url    = "${local.api_base}/rest/api/2/issue/${param.issue_id}/comment"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"   
    }
    request_body = jsonencode({
      body = param.comment_text
    })
  }

  output "status" {
    value = step.http.add_comment.status
  }
}
