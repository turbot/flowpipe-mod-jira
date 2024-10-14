pipeline "transition_issue" {
  title       = "Transition Issue"
  description = "Performs an issue transition updates the fields from the transition."

  param "conn" {
    type        = connection.jira
    description = local.conn_param_description
    default     = connection.jira.default
  }

  param "issue_id" {
    type        = string
    description = local.issue_id_param_description
  }

  param "transition_id" {
    description = "ID of the transition for closing the issue."
    type        = number
  }

  step "http" "transition_issue" {
    method = "post"
    url    = "${param.conn.base_url}/rest/api/2/issue/${param.issue_id}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    request_body = jsonencode({
      transition = {
        id = param.transition_id
      }
    })

    basic_auth {
      username = param.conn.username
      password = param.conn.api_token
    }
  }
}
