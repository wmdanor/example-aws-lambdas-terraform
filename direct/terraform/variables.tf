variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_role_to_assume" {
  type = string
}

variable "upload_lambda_assets" {
  type        = bool
  description = "Determines if new Lambda assets should be uploaded and used as new version"
}
