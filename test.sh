#!/bin/bash

set -euo pipefail

ISSUE_ID=""  # Global variable to store issue ID

validate_date() {
    local date="$1"
    [[ "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]
    return $?  # Return the status of the regex match
}


# Test functions for each operation

test_create_issue() {
    local TEST_NAME="create_issue"
    local output
    output=$(flowpipe pipeline run jira.pipeline.create_issue --pipeline-arg summary="Test Issue" --pipeline-arg description="This is a test issue description." --execution-mode synchronous 2>&1)
    
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # Extracting issue_id from the output
    ISSUE_ID=$(echo "$output" | jq -r '.issue_id')

    if [[ ! -z $ISSUE_ID ]]; then
        echo "[$TEST_NAME] PASS: Valid issue_id ($ISSUE_ID) retrieved."
    else
        echo "[$TEST_NAME] FAIL: Invalid or missing issue_id."
        exit 1
    fi
}

test_list_issues() {
    local TEST_NAME="list_issues"
    local output=$(flowpipe pipeline run jira.pipeline.list_issues --execution-mode synchronous 2>&1)
    local issues_json=$(echo "$output" | jq -r '.issues')
    
    local first_issue=$(echo "$issues_json" | jq -r '.[0]')
    if ! echo "$first_issue" | jq 'has("fields")' | grep -q true; then
        echo "[$TEST_NAME] FAIL: 'fields' attribute missing in the first issue."
        exit 1
    fi

    if ! echo "$first_issue" | jq '.fields | has("created")' | grep -q true; then
        echo "[$TEST_NAME] FAIL: created field missing in the first issue."
        exit 1
    fi

    local date_value=$(echo "$first_issue" | jq -r ".fields.created" | cut -d. -f1)

    if [[ "$date_value" != "null" ]] && ! validate_date "$date_value"; then
        echo "[$TEST_NAME] FAIL: Invalid date format for created in the first issue."
        exit 1
    fi

    echo "[$TEST_NAME] PASS: The created field in the first issue is present and has a valid format."
}



test_get_issue() {
    local TEST_NAME="get_issue"
    local output=$(flowpipe pipeline run jira.pipeline.get_issue --pipeline-arg issue_id="$ISSUE_ID" --execution-mode synchronous)
    local display_id=$(echo "$output" | jq -r '.issue_details.id')
    
    if [ "$display_id" == "$ISSUE_ID" ]; then
        echo "[$TEST_NAME] PASS: display_id matches issue_id."
    else
        echo "[$TEST_NAME] FAIL: display_id does not match issue_id."
    fi
}

test_update_issue() {
    local TEST_NAME="update_issue"
    local update_output=$(flowpipe pipeline run jira.pipeline.update_issue --pipeline-arg issue_id="$ISSUE_ID" --pipeline-arg summary="Updated issue summary." --pipeline-arg description="Updated issue description." --execution-mode synchronous 2>&1)
    
    if [ $? -ne 0 ]; then
        echo "[$TEST_NAME] FAIL: Error while updating the issue: $update_output"
        exit 1
    fi

    local get_issue_output=$(flowpipe pipeline run jira.pipeline.get_issue --pipeline-arg issue_id="$ISSUE_ID" --execution-mode synchronous 2>&1)
    local issue_description=$(echo "$get_issue_output" | jq -r '.issue_details.fields.description')
    
    if [[ "$issue_description" == "Updated issue description." ]]; then
        echo "[$TEST_NAME] PASS: Issue description updated successfully."
    else
        echo "[$TEST_NAME] FAIL: Issue description is not updated. Current description: $issue_description"
        exit 1
    fi
}


test_add_comment() {
    local TEST_NAME="add_comment"
    local output=$(flowpipe pipeline run jira.pipeline.add_comment --pipeline-arg issue_id="$ISSUE_ID" --pipeline-arg comment_text="This is a test comment." --execution-mode synchronous)
    local status=$(echo "$output" | jq -r '.status')
    
    if [[ "$status" == "201 Created" ]]; then
        echo "[$TEST_NAME] PASS: Comment added successfully with status 201 Created."
    else
        echo "[$TEST_NAME] FAIL: Failed to add comment. Status received: $status."
        exit 1
    fi
}

test_delete_issue() {
    local TEST_NAME="delete_issue"
    local output=$(flowpipe pipeline run jira.pipeline.delete_issue --pipeline-arg issue_id="$ISSUE_ID" --execution-mode synchronous)
    local status=$(echo "$output" | jq -r '.status')
    
    if [[ "$status" == "204 No Content" ]]; then
        echo "[$TEST_NAME] PASS: Issue deleted successfully with status 204 No Content."
    else
        echo "[$TEST_NAME] FAIL: Failed to delete issue. Status received: $status."
        exit 1
    fi
}

test_create_issue
test_list_issues
test_get_issue
test_update_issue
test_add_comment
test_delete_issue
