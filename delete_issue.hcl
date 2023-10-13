pipeline "delete_issue" {
  description = "Delete a Jira issue"

  param "token" {
    type    = string
    default = var.token
  }

  param "issue_id" {
    type    = number
  }  

  step "http" "delete_issue" {
    method = "delete"
    url    = "${local.api_base}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"   
    }
  }

  output "status" {
    value = step.http.delete_issue.status
  }  

}