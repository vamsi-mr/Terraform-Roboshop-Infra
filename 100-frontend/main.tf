module "frontend" {
  source = "git::https://github.com/vamsi-mr/Terraform-aws-roboshop.git?ref=main"
  component = "frontend"
  rule_priority = 30
}