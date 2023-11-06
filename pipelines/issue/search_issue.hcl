pipeline "search_issues_by_jql" {
  title       = "Search Issues in Jira"
  description = "Search for issues in Jira based on JQL."

  param "api_base_url" {
    type        = string
    description = "API base URL for your Jira instance."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "API access token for authentication."
    default     = var.token
    # TODO: Add once supported
    # sensitive  = true
  }

  param "user_email" {
    type        = string
    description = "The email ID of the Jira user."
    default     = var.user_email
  }

  param "jql_query" {
    type        = string
    description = "JQL query for searching issues."
    default     = "project = test-turbot"
  }

  step "http" "search_issues_by_jql" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/3/search?jql=${urlencode(param.jql_query)}"
    request_headers = {
      Accept = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }
  }

  output "issues" {
    description = "List of issues matching the JQL query."
    value       = step.http.search_issues_by_jql.response_body
  }
}