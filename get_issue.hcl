
pipeline "get_issue" {
  description = "Retrieve details of a specific Jira issue."

  param "token" {
    type    = string
    default = var.token
  }

  param "issue_id" {
    type = string
  }

  step "http" "get_issue_details" {
    method = "get"
    url    = "${local.api_base}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"   
    }
  }

  output "issue_details" {
    value = jsondecode(step.http.get_issue_details.response_body)
  }
}
