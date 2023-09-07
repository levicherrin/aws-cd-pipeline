terraform {
  backend "s3" {
    bucket         = "MY-BUCKET"
    key            = "pipeline-terraform.tfstate"
    region         = "MY-REGION"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    profile        = "MY-PROFILE"
    role_arn       = "MY-ROLE"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#tools provider
provider "aws" {
  shared_config_files      = ["MY-DIRECTORY"]
  shared_credentials_files = ["MY-DIRECTORY"]
  profile                  = "MY-PROFILE"
  assume_role {
    role_arn = var.tools_role
  }
}

module "common" {
  source = "../modules/common"
  # Input Variables
  tools_role = var.tools_role
  test_role = var.test_role
  prod_role = var.prod_role
  state_bucket_arn = var.state_bucket_arn
}

module "test_pipeline" {
  source = "../modules/pipeline"
  # Input Variables
  deploy_role = var.test_role
  repo_id = var.repo_id
  branch_name = var.test_branch_name
  pipeline_name = var.test_pipeline_name
  env = var.test_env
  execution_role = module.common.pipeline_role
  encryption_key = module.common.encryption_key_arn
  artifact_store = module.common.artifact_store
  connection_arn = module.common.connection_arn
}