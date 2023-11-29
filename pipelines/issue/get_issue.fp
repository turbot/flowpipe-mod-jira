
pipeline "get_issue" {
  title       = "Get an issue detail"
  description = "Retrieve details about the issue."

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

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "get_issue_details" {
    method = "get"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

  }

  output "issue" {
    description = "Details about the issue."
    value       = step.http.get_issue_details.response_body
  }
}
