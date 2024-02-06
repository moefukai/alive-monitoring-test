data "aws_ecr_repository" "web" {
  name = var.web_image_repository_name
}

data "aws_ecr_repository" "app" {
  name = var.app_image_repository_name
}
