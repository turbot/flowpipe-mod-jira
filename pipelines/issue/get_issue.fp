
pipeline "get_issue" {
  title       = "Get an issue detail"
  description = "Retrieve details about the issue."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "get_issue_details" {
    method = "get"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_id}"
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
    value       = step.http.get_issue_details.response_body
  }
}
