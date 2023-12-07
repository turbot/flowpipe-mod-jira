pipeline "update_issue" {
  title       = "Update an Issue"
  description = "Update fields of an existing issue."

  tags = {
    type = "featured"
  }

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
    type        = string
    description = local.issue_id_param_description
  }

  param "summary" {
    type        = string
    description = "Issue summary."
  }

  param "description" {
    type        = string
    description = "Issue description."
    optional    = true
  }

  param "priority" {
    type        = string
    description = "Issue priority."
    optional    = true
  }

  param "assignee_id" {
    type        = string
    description = "Assignee id."
    optional    = true
  }

  step "http" "update_issue" {
    method = "put"
    url    = "${param.api_base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = param.user_email
      password = param.token
    }

    request_body = jsonencode({
      fields = {
        summary     = param.summary,
        description = param.description != null ? param.description : null,
        priority    = param.priority != null ? { name = param.priority } : { name = "Medium" },
        assignee    = param.assignee_id != null ? { id = param.assignee_id } : {}
      }
    })
  }

}