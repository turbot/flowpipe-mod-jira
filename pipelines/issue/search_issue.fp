pipeline "search_issues_by_jql" {
  title       = "Search Issues"
  description = "Search for issues in Jira based on JQL."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
  }

  step "http" "search_issues_by_jql" {
    method = "get"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/search?jql=${urlencode(param.jql_query)}"
    request_headers = {
      Accept = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }

    error {
      ignore = true
    }
  }

  output "issues" {
    description = "List of issues matching the JQL query."
    value       = step.http.search_issues_by_jql.status_code == 400 ? null : step.http.search_issues_by_jql.response_body.issues
  }
}