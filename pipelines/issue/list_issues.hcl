pipeline "list_issues" {
  description = "List of issues in a Jira project."

  param "project_key" {
    type    = string
    default = var.project_key
  }

  step "http" "list_issues" {
    method = "get"
    url    = "${local.api_base}/rest/api/2/search?jql=project=${param.project_key}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"      
    }
  }

  output "issues" {
    value = jsondecode(step.http.list_issues.response_body).issues
  }
  output "total_issues" {
    value = jsondecode(step.http.list_issues.response_body).total
  }

}