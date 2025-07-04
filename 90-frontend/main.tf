module "user" {
  source = "../../Terraform-aws-roboshop"
  component = "frontend"
  rule_priority = 20
}