mod "jira" {
  title         = "Jira"
  description   = "Run pipelines to supercharge your Jira workflows using Flowpipe."
  color         = "#2684FF"
  documentation = file("./README.md")
  icon          = "/images/mods/turbot/jira.svg"
  categories    = ["library", "productivity"]

  opengraph {
    title       = "Jira Library Mod for Flowpipe"
    description = "Run pipelines to supercharge your Jira workflows using Flowpipe."
    image       = "/images/mods/turbot/jira-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}