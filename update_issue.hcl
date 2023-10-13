pipeline "update_issue" {
  description = "Update an existing Jira issue."

  param "token" {
    type    = string
    default = var.token
  }

  param "issue_id" {
    type = string
  }

  param "summary" {
    type = string
  }

  param "description" {
    type = string
  }

  step "http" "update_issue" {
    method = "put"
    url    = "${local.api_base}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"   
    }
    request_body = jsonencode({
      fields = {
        summary     = param.summary,
        description = param.description
      }
    })
  }

  output "response_body" {
    value = step.http.update_issue.status
  }

}