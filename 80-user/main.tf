module "user" {
  source = "../../Terraform-aws-roboshop"
  component = "user"
  rule_priority = 30
}