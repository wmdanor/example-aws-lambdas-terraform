
module "uppercaser" {
  source = "./modules/lambda"

  function_name       = "go-uppercaser"
  asset_path          = "../assets/lambda/uppercaser.zip"
  upload_lambda_asset = var.upload_lambda_assets
}

# module "lowercaser" {
#   source = "./modules/lambda"

#   function_name = "go-lowercaser"
#   asset_path    = "../assets/lambda/lowercaser.zip"
# }
