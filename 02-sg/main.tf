module "frontend" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group" "frontend_allow_all" {
  name        = "allow_all"
  description = "allow all traffic"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

module "bastion" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#bastion accepting connection from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type =  "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}