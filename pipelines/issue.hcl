pipeline "list_issues" {
  description = "List of issues in a Jira project."

  param "jira_project_key" {
    type    = string
    default = var.jira_project_key
  }

  step "http" "list_issues" {
    method = "get"
    url    = "${var.jira_base}/rest/api/2/search?jql=project=${param.jira_project_key}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"      
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
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"   
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

  # return whole issue

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
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"   
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

# if api gives back issue, output it, else status
  step "http" "update_issue" {
    method = "put"
    url    = "${var.jira_base}/rest/api/2/issue/${param.jira_issue_id}"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"   
    }
    request_body = jsonencode({
      fields = {
        summary     = param.summary,
        description = param.description
      }
    })
  }
}

pipeline "get_issue" {
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
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"   
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
      Authorization = "Basic ${base64encode("${var.jira_user_email}:${var.jira_token}")}"   
    }
    request_body = jsonencode({
      body = param.comment_text
    })
  }

  output "comment_id" {
    value = jsondecode(step.http.add_comment.response_body).id
  }
}
