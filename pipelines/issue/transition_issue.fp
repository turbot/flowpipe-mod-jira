pipeline "transition_issue" {
  title       = "Transition Issue"
  description = "Performs an issue transition updates the fields from the transition."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_id}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    request_body = jsonencode({
      transition = {
        id = param.transition_id
      }
    })

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }
  }
}
