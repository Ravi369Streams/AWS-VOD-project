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
}
