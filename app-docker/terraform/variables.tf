variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_role_to_assume" {
  type = string
}

variable "ecr_repository_name" {
  type    = string
  default = "app-docker-lambdas"
}
