module "frontend" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}