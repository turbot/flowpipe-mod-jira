pipeline "list_issues" {
  title       = "List Issues"
  description = "List of issues in a Jira project."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "project_key" {
    type        = string
    description = local.project_key_param_description
  }

  step "http" "list_issues" {
    method = "get"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/search?jql=project=${param.project_key}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }

    loop {
      until = result.response_body.startAt + length(result.response_body.issues) >= result.response_body.total
      url   = "${credential.jira[param.cred].base_url}/rest/api/2/search?jql=project=${param.project_key}&startAt=${result.response_body.startAt + length(result.response_body.issues)}"
    }
  }

  output "issues" {
    description = "List of issues."
    value = {
      issues = flatten([for issue in step.http.list_issues : issue.response_body.issues])
    }
  }

}