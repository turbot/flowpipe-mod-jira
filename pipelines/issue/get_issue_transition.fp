pipeline "get_issue_transitions" {
  title       = "Get Issue Transitions"
  description = "Returns either all transitions or a transition that can be performed by the user on an issue, based on the issue's status."

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_key" {
    type        = string
    description = "Key of the Jira issue to get transitions for."
  }

  step "http" "get_issue_transitions" {
    method = "get"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_key}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
    }
  }

  output "transitions" {
    description = "Details about available transitions for the issue."
    value       = step.http.get_issue_transitions.response_body.transitions
  }
}
