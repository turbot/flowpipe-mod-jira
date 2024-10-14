pipeline "update_issue" {
  title       = "Update Issue"
  description = "Update fields of an existing issue."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_id" {
    type        = string
    description = local.issue_id_param_description
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

  step "http" "update_issue" {
    method = "put"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
    }

    request_body = jsonencode({
      fields = merge({
        summary     = param.summary,
        description = param.description != null ? param.description : null,
        assignee    = param.assignee_id != null ? { id = param.assignee_id } : {}
        },
        param.assignee != null ? { assignee = { id = param.assignee_id } } : {},
        param.priority != null ? { priority = { name = param.priority } } : {}
      )
    })
  }

}