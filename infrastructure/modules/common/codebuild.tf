resource "aws_codebuild_project" "validate" {
  name          = "validate"
  build_timeout = "5"
  service_role  = aws_iam_role.pipeline.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "templates/buildspec-validate.yml"
  }
}

resource "aws_codebuild_project" "plan" {
  name          = "plan"
  build_timeout = "5"
  service_role  = aws_iam_role.pipeline.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "templates/buildspec-plan.yml"
  }
}

resource "aws_codebuild_project" "apply" {
  name          = "apply"
  build_timeout = "10"
  service_role  = aws_iam_role.pipeline.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "templates/buildspec-apply.yml"
  }
}