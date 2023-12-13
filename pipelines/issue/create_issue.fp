pipeline "create_issue" {
  title       = "Create Issue"
  description = "Create a new issue in a Jira project."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "project_key" {
    type        = string
    description = local.project_key_param_description
  }

  param "issue_type" {
    type        = string
    description = "Issue type."
  }

  param "summary" {
    type        = string
    description = "Issue summary."
  }

  param "description" {
    type        = string
    description = "Issue description."
    optional    = true
  }

  param "priority" {
    type        = string
    description = "Issue priority."
    optional    = true
  }

  param "assignee_id" {
    type        = string
    description = "Assignee id."
    optional    = true
  }

  step "http" "create_issue" {
    method = "post"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }

    request_body = jsonencode({
      fields = merge({
        project = {
          key = param.project_key
        },
        summary     = param.summary,
        description = param.description != null ? param.description : null,
        issuetype = {
          name = param.issue_type
        },
        assignee = param.assignee_id != null ? { id = param.assignee_id } : {}
        },

        param.priority != null ? { priority = { name = param.priority } } : {}
      )
    })
  }

  output "issue" {
    description = "Details about the issue."
    value       = step.http.create_issue.response_body
  }
}
