
resource "aws_ecr_repository" "repo" {
  name = var.ecr_repository_name
}

module "uppercaser" {
  source = "./modules/lambda"

  function_name       = "docker-uppercaser"
  ecr_repository_name = aws_ecr_repository.repo.name
  image_tag           = "uppercaser-latest"
}

module "lowercaser" {
  source = "./modules/lambda"

  function_name       = "docker-lowercaser"
  ecr_repository_name = aws_ecr_repository.repo.name
  image_tag           = "lowercaser-latest"
}
