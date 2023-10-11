pipeline "list_issues" {
  description = "List of issues in a Jira project."

  param "jira_token" {
    type    = string
    default = var.jira_token
  }

  param "jira_project_key" {
    type    = string
    default = var.project
  }

  step "http" "list_issues" {
    title  = "List of issues in a Jira project."
    method = "get"
    url    = "${var.base}/rest/api/2/search?jql=project=${param.jira_project_key}"
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
    default = "LW"
  }

  param "issue_type" {
    type = string
    default = "Bug"  // Defaulting to "Bug", but this can be any valid issue type like "Task", "Story", etc.
  }

  param "summary" {
    type = "test1"
  }

  param "description" {
    type = "test 1 desc"
  }

  step "http" "create_issue" {
    title  = "Create a new Jira issue."
    method = "post"
    url    = "https://yourdomain.atlassian.net/rest/api/2/issue"
    request_headers = {
      Content-Type  = "application/json"
      Authorization = "Basic ${param.jira_token}"
    }
    request_body = {
      fields: {
        project: {
          key: "${param.project_key}"
        },
        summary: "${param.summary}",
        description: "${param.description}",
        issuetype: {
          name: "${param.issue_type}"
        }
      }
    }
  }

  output "issue_id" {
    value = jsondecode(step.http.create_issue.response_body).id
  }
}

