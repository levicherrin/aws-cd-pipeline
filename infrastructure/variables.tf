variable "tools_role" {
  type = string
  sensitive = true
  default = ""
}

variable "test_role" {
  type = string
  sensitive = true
  default = ""
}

variable "prod_role" {
  type = string
  sensitive = true
  default = ""
}

variable "repo_id" {
  type = string
  default = ""
}

variable "test_branch_name" {
  type = string
  default = "dev"
}

variable "test_pipeline_name" {
  type = string
  default = "test_web_host_pipeline"
}

variable "state_bucket_arn" {
  type = string
  default = ""
}

variable "test_env" {
  type = string
  default = "test"
}