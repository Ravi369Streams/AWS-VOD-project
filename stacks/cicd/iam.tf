resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  name = "s3_access_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:PutObject"
      ],
      Effect = "Allow"
      resource = "${aws_s3_bucket.vod-project-artifacts-bucket.arn}/*"
    }]
  })
}

resource "aws_iam_role_policy" "codepipeline_secure_access_policy" {
  name = "SSEAndSSLPolicy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "DenyUnEncryptedObjectUploads"
        Action = "s3:PutObject",
        Effect = "Deny"
        resource = "${aws_s3_bucket.vod-project-artifacts-bucket.arn}/*"
        condition = {
          "StringNotEquals": {
            "s3:x-amz-server-side-encryption": "aws:kms"
          }
        }
      },
      {
        Sid = "DenyInsecureConnections"
        Action = "s3:*",
        Effect = "Deny"
        resource = "${aws_s3_bucket.vod-project-artifacts-bucket.arn}/*"
        condition = {
          "Bool": {
            "aws:SecureTransport": false
          }
        }
      }
    ]
  })
}
