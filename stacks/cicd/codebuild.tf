resource "aws_codebuild_project" "build-project" {
  name = var.repo_configuration.codebuild_name
  description = "Builds and deploys the project to AWS"
  build_timeout = var.repo_configuration.codebuild_build_timeout

  # todo: create seperate role for codebuild
  service_role = aws_iam_role.codepipeline_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:7.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "codebuild-logs"
    }
  }

  source {
    type = "NO_SOURCE"
    buildspec = file("${path.module}/config/buildspec.yml")
  }
}
