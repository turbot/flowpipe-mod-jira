pipeline "list_issues" {
  description = "List of issues in a Jira project."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_project_key" {
    type    = string
    default = var.jira_project_key
  }

  step "http" "list_issues" {
    method = "get"
    url    = "${var.jira_base}/rest/api/2/search?jql=project=${param.jira_project_key}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${param.jira_token}"
    }
  }

  output "issues" {
    value = jsondecode(step.http.list_issues.response_body).issues
  }
  output "total_issues" {
    value = jsondecode(step.http.list_issues.response_body).total
  }
  output "response_body" {
    value = step.http.list_issues.response_body
  }
  output "response_headers" {
    value = step.http.list_issues.response_headers
  }
  output "status_code" {
    value = step.http.list_issues.status_code
  }
}

pipeline "create_issue" {
  description = "Create a new Jira issue."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_project_key" {
    type    = string
    default = var.jira_project_key
  }

  param "issue_type" {
    type = string
    default = "Task"  
  }

  param "summary" {
    type = string
    default = "summary"
  }

  param "description" {
    type = string
    default = "summary"
  }

  step "http" "create_issue" {
    method = "post"
    url    = "${var.jira_base}/rest/api/2/issue"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${param.jira_token}"
    }
    request_body = jsonencode({
      fields = {
        project = {
          key = param.jira_project_key
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

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_issue_id" {
    type    = string
  }  

  step "http" "delete_issue" {
    method = "delete"
    url    = "${var.jira_base}/rest/api/2/issue/${param.jira_issue_id}"
    request_headers = {
      Authorization = "Basic ${param.jira_token}"
    }
  }  

}

pipeline "update_issue" {
  description = "Update an existing Jira issue."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_issue_id" {
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
    url    = "${var.jira_base}/rest/api/2/issue/${param.jira_issue_id}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${param.jira_token}"
    }
    request_body = jsonencode({
      fields = {
        summary     = param.summary,
        description = param.description
      }
    })
  }
}

pipeline "get_issue_details" {
  description = "Retrieve details of a specific Jira issue."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_issue_id" {
    type = string
  }

  step "http" "get_issue_details" {
    method = "get"
    url    = "${var.jira_base}/rest/api/2/issue/${param.jira_issue_id}"
    request_headers = {
      Authorization = "Basic ${param.jira_token}"
    }
  }

  output "issue_details" {
    value = jsondecode(step.http.get_issue_details.response_body)
  }
}

pipeline "add_comment" {
  description = "Add a comment to a Jira issue."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_issue_id" {
    type = string
  }

  param "comment_text" {
    type = string
  }

  step "http" "add_comment" {
    method = "post"
    url    = "${var.jira_base}/rest/api/2/issue/${param.jira_issue_id}/comment"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${param.jira_token}"
    }
    request_body = jsonencode({
      body = param.comment_text
    })
  }

  output "comment_id" {
    value = jsondecode(step.http.add_comment.response_body).id
  }
}
