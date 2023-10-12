locals {
  api_base = "https://${var.subdomain}.atlassian.net"
}

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
