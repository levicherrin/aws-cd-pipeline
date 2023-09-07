output "pipeline_role" {
  value = aws_iam_role.pipeline.arn
}

output "encryption_key_arn" {
  value = aws_kms_key.this.arn
}

output "artifact_store" {
  value = aws_s3_bucket.artifacts.id
}

output "connection_arn" {
  value = aws_codestarconnections_connection.this.arn
}