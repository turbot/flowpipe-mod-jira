pipeline "delete_issue" {
  title       = "Delete an Issue"
  description = "Delete an issue from a project in Jira.(Note:An issue cannot be deleted if it has one or more subtasks.)"

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "issue_id" {
    type        = number
    description = local.issue_id_param_description
  }

  step "http" "delete_issue" {
    method = "delete"
    url    = "${credential.jira[param.cred].base_url}/rest/api/2/issue/${param.issue_id}"
    request_headers = {
      Content-Type = "application/json"
    }

    basic_auth {
      username = credential.jira[param.cred].username
      password = credential.jira[param.cred].api_token
    }
  }
}