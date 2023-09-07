variable "tools_role" {}

variable "test_role" {}

variable "prod_role" {}

variable "state_bucket_arn" {}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}