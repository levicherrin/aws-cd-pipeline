resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = var.execution_role

  artifact_store {
    location = var.artifact_store
    type     = "S3"

    encryption_key {
      id   = var.encryption_key
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Download-Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.connection_arn
        FullRepositoryId = var.repo_id
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Validate"

    action {
      name             = "Terraform-Validate"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["validate_output"]
      version          = "1"

      configuration = {
        ProjectName = "validate"
        EnvironmentVariables = jsonencode([{"name":"TF_VAR_env","value":"${var.env}","type":"PLAINTEXT"}])
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Terraform-Plan"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output", "validate_output"]
      output_artifacts = ["plan_output"]
      version          = "1"
      configuration = {
        ProjectName = "plan"
        PrimarySource = "source_output"
        EnvironmentVariables = jsonencode([{"name":"TF_VAR_env","value":"${var.env}","type":"PLAINTEXT"}])
      }
    }
  }

  stage {
    name = "Review"

    action {
      name             = "Review-Plan"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      input_artifacts  = []
      output_artifacts = []
      version          = "1"

      configuration = {
        CustomData = "Review tfplan and validation reports before approving"
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name             = "Terraform-Apply"
      namespace = "infra_vars"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output", "plan_output"]
      output_artifacts = ["website"]
      version          = "1"

      configuration = {
        ProjectName = "apply"
        PrimarySource = "source_output"
        EnvironmentVariables = jsonencode([{"name":"TF_VAR_env","value":"${var.env}","type":"PLAINTEXT"}])
      }

      run_order = 1
    }

    action {
      name             = "S3-Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "S3"
      input_artifacts  = ["website"]
      output_artifacts = []
      version          = "1"

      configuration = {
        BucketName = "#{infra_vars.WEBSITE_BUCKET}"
        Extract = true
      }

      role_arn = var.deploy_role
      run_order = 2
    }
  }
}