variable "function_name" {
  type = string
}

variable "asset_path" {
  type        = string
  description = "Path to the lambda asset, if null, then lambda code will not be changed"
}

variable "upload_lambda_asset" {
  type        = bool
  description = "Determines if new Lambda asset should be uploaded and used as new version"
}

variable "preserve_assets_days" {
  type        = number
  description = "Number of days until non-latest asset version will be deleted"
  default     = 1
}

variable "preserve_assets_amount" {
  type        = number
  description = "Maximum number of non-latest assets version that can be preserved"
  default     = 1
}
