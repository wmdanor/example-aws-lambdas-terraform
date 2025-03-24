locals {
  lambda_asset_source_hash = var.upload_lambda_asset ? filemd5(var.asset_path) : data.aws_s3_object.lambda_asset[0].etag
}
