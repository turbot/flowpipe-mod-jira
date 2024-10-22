pipeline "get_issue" {
  title       = "Get Issue"
  description = "Returns the details for an issue."

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "get_issue_details" {
    method = "get"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}"
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
    value       = step.http.get_issue_details.response_body
  }
}
