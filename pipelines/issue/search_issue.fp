pipeline "search_issues_by_jql" {
  title       = "Search Issues in Jira"
  description = "Search for issues in Jira based on JQL."

  param "api_base_url" {
    type        = string
    description = local.api_base_url_param_description
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = local.token_param_description
    default     = var.token
  }

  param "user_email" {
    type        = string
    description = local.user_email_param_description
    default     = var.user_email
  }

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
  }

  step "http" "search_issues_by_jql" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/2/search?jql=${urlencode(param.jql_query)}"
    request_headers = {
      Accept = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
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