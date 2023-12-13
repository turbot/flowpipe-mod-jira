pipeline "get_issue_transitions" {
  title       = "Get Issue Transitions"
  description = "Returns either all transitions or a transition that can be performed by the user on an issue, based on the issue's status."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "issue_key" {
    type        = string
    description = "Key of the Jira issue to get transitions for."
  }

  step "http" "get_issue_transitions" {
    method = "get"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_key}/transitions"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }
  }

  output "transitions" {
    description = "Details about available transitions for the issue."
    value       = step.http.get_issue_transitions.response_body.transitions
  }
}
