resource "aws_s3_bucket" "lambda_assets" {
  bucket_prefix = var.function_name
}

resource "aws_s3_bucket_versioning" "lambda_assets" {
  bucket = aws_s3_bucket.lambda_assets.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lambda_assets" {
  depends_on = [aws_s3_bucket_versioning.lambda_assets]

  bucket = aws_s3_bucket.lambda_assets.bucket

  rule {
    id     = "preserve-latest"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      newer_noncurrent_versions = var.preserve_assets_amount
      noncurrent_days           = var.preserve_assets_days
    }

  }
}

data "aws_s3_object" "lambda_asset" {
  count = var.upload_lambda_asset ? 0 : 1

  bucket = aws_s3_bucket.lambda_assets.bucket
  key    = "asset.zip"
}

resource "aws_s3_object" "lambda_asset" {
  depends_on = [aws_s3_bucket_lifecycle_configuration.lambda_assets]

  bucket = aws_s3_bucket.lambda_assets.bucket
  key    = "asset.zip"

  source = var.asset_path

  source_hash = local.lambda_asset_source_hash
}
