resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = aws_iam_role.lambda.arn

  runtime       = "provided.al2023"
  architectures = ["arm64"]

  package_type = "Zip"
  handler      = "bootstrap"

  s3_bucket = aws_s3_object.lambda_asset.bucket
  s3_key    = aws_s3_object.lambda_asset.key

  source_code_hash = local.lambda_asset_source_hash

  memory_size = 128
}
