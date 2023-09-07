resource "aws_codestarconnections_connection" "this" {
  name          = "web-host-connection"
  provider_type = "GitHub"
}

resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "pipeline-artifacts-"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["s3:*"]
    resources = [aws_s3_bucket.artifacts.arn, "${aws_s3_bucket.artifacts.arn}/*"]
    
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.pipeline.arn, var.test_role, var.prod_role]
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "key for pipeline artifacts"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms.json
}