
module "uppercaser" {
  source = "./modules/lambda"

  function_name = "direct-uppercaser"
}

module "lowercaser" {
  source = "./modules/lambda"

  function_name = "direct-lowercaser"
}
