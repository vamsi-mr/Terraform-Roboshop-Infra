module "user" {
  source = "git::https://github.com/vamsi-mr/Terraform-aws-roboshop.git?ref=main"
  component = "user"
  rule_priority = 20
}