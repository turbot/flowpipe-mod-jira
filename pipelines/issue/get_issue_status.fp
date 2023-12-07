
pipeline "get_issue_status" {
  title       = "Get an issue status"
  description = "Retrieve issue by status."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  # Here we can pass issue ID as well as issue KEY
  param "issue_id" {
    type        = string
    description = local.issue_id_param_description
  }

  step "http" "get_issue_status" {
    method = "get"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_id}?fields=status"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }

  }

  output "issue" {
    description = "Details about the issue."
    value       = step.http.get_issue_status.response_body
  }
}
