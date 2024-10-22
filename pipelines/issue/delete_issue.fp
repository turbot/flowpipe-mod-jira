pipeline "delete_issue" {
  title       = "Delete Issue"
  description = "Delete an issue from a project in Jira. An issue cannot be deleted if it has one or more subtasks."

  tags = {
    recommended = "true"
  }

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "delete_issue" {
    method = "delete"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
    }
  }
}