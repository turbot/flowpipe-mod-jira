
pipeline "get_issue_status" {
  title       = "Get Issue Status"
  description = "Retrieve issue by status."

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_id" {
    type        = string
    description = local.issue_id_param_description
  }

  step "http" "get_issue_status" {
    method = "get"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}?fields=status"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
    }

  }

  output "issue" {
    description = "Details about the issue."
    value       = step.http.get_issue_status.response_body
  }
}
