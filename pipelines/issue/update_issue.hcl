pipeline "update_issue" {
  title       = "Update an Issue"
  description = "Update an existing issue."

  param "api_base_url" {
    type        = string
    description = "API base url."
    default     = var.api_base_url
  }

  param "token" {
    type        = string
    description = "API access token."
    default     = var.token
    # TODO: Add once supported
    # sensitive  = true
  }

  param "user_email" {
    type        = string
    description = "Email-id of the user."
    default     = var.user_email
  }

  param "issue_id" {
    description = "Issue ID."
    type        = string
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