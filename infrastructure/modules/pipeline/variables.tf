variable "deploy_role" {}

variable "execution_role" {}

variable "repo_id" {}

variable "branch_name" {}

variable "pipeline_name" {}

variable "env" {}

variable "encryption_key" {}

variable "artifact_store" {}

variable "connection_arn" {}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}


