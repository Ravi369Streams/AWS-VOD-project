remote_state {
  backend = "s3"
  config = {
    bucket         = "vod-project-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOF
  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

  provider "aws" {
    region = "eu-central-1"
    default_tags {
      tags = {
        project = "VOD-project"
      }
    }
  }
  EOF
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOF
  terraform {
    backend "s3" {}
  }
  EOF
}
