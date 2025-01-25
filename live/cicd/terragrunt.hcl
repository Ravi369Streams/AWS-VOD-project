include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/stacks/cicd"
}

inputs = {
  additional_default_tags = {
    sub-project = "cicd"
  }
  repo_configuration = {
    codestar_connection_name = "vod-project-github-repo"
    codestar_provider_type = "Github"
    codepipeline_name = "vod-project-pipeline"
    codebuild_name = "vod-project-build-and-deploy"
    codebuild_build_timeout = 30
    repo_id = "Ravi369Streams/AWS-VOD-project"
    repo_branch = "main"
    repo_detect_changes = false
  }
}
