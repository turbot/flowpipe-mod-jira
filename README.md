# Jira Mod for Flowpipe

Jira pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of Jira services into your workflows.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/jira/pipelines)**

## Getting started

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

### Connections

By default, the following environment variables will be used for authentication:

- `JIRA_API_TOKEN`
- `JIRA_URL`
- `JIRA_USER`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/jira.fpc
```

```hcl
connection "jira" "jira_cred" {
  base_url    = "https://test.atlassian.net/"
  api_token   = "ATATT3........."
  username    = "abc@email.com"
}
```

For more information on connections in Flowpipe, please see [Managing connections](https://flowpipe.io/docs/run/connections).

### Usage

[Initialize a mod](https://flowpipe.io/docs/build/index#initializing-a-mod):

```sh
mkdir my_mod
cd my_mod
flowpipe mod init
```

[Install the Jira mod](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies) as a dependency:

```sh
flowpipe mod install github.com/turbot/flowpipe-mod-jira
```

[Use the dependency](https://flowpipe.io/docs/build/write-pipelines/index) in a pipeline step:

```sh
vi my_pipeline.fp
```

```hcl
pipeline "my_pipeline" {

  step "pipeline" "list_issues" {
    pipeline = jira.pipeline.list_issues
    args = {
      project_key = "SBT"
    }
  }
}
```
[Run the pipeline](https://flowpipe.io/docs/run/pipelines):

```sh
flowpipe pipeline run my_pipeline
```

### Developing

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-jira.git
cd flowpipe-mod-jira
```

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```sh
flowpipe pipeline run list_issues --arg project_key=SBT
```

To use a specific `connection`, specify the `conn` pipeline argument:

```sh
flowpipe pipeline run list_issues --arg conn=jira_profile --arg project_key=SBT
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [JIRA Mod](https://github.com/turbot/flowpipe-mod-jira/labels/help%20wanted)
