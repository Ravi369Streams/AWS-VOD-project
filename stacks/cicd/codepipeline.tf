resource "aws_s3_bucket" "vod-project-artifacts-bucket" {
  bucket = "vod-project-artifacts-bucket"
}

resource "aws_codestarconnections_connection" "connect-to-github" {
  name = var.repo_configuration.codestar_connection_name
  provider_type = var.repo_configuration.codestar_connection_type
}

resource "aws_codepipeline" "project-pipeline" {
  name = var.repo_configuration.codepipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.vod-project-artifacts-bucket.bucket
    type = "S3"

    encryption_key {
      id = data.aws_kms_alias.s3kmskey.arn
      type = "KMS"
    }
  }
  # The source stage might need some adjustments depending on where your
  # code is located. Please check the documentation and adjust the code
  # below accordingly.
  # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html
  stage {
    name = "Source"

    action {
      name = "Github"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = 1

      configuration = {
        ConnectionArn = aws_codestarconnections_connection.connect-to-github.arn
        FullRepositoryId = var.repo_configuration.repo_id
        BranchName = var.repo_configuration.repo_branch
        OutputArtifactFormat = "CODE_ZIP"
        DetectChanges = var.repo_configuration.repo_detect_changes
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = 1

      configuration = {
        ProjectName = "" # todo
        BatchEnabled = false
      }
    }
  }
}
