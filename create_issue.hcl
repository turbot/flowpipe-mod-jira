pipeline "create_issue" {
  description = "Create a new Jira issue."

  param "project_key" {
    type    = string
    default = var.project_key
  }

  param "issue_type" {
    type = string
    default = "Task"  
  }

  param "summary" {
    type = string
  }

  param "description" {
    type = string
  }

  step "http" "create_issue" {
    method = "post"
    url    = "${local.api_base}/rest/api/2/issue"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.user_email}:${var.token}")}"   
    }
    request_body = jsonencode({
      fields = {
        project = {
          key = param.project_key
        },
        summary = param.summary,
        description =  param.description,
        issuetype = {
          name = param.issue_type
        }
      }
    })
  }

  output "issue_id" {
    value = jsondecode(step.http.create_issue.response_body).id
  }
}