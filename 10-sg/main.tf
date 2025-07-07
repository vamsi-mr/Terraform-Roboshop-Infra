module "bastion" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#bastion accepting connection from my local network through ssh 
resource "aws_security_group_rule" "bastion_local" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

module "backend_alb" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.backend_alb
  sg_description = var.backend_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#backend alb accepting connections from my bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# backend alb accepting connections from my vpn host on port no 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}


module "vpn" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.vpn_sg
  sg_description = var.vpn_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

#vpn ports 22, 443, 1194,943
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

##Mongodb security group
module "mongodb" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.mongodb_sg
  sg_description = var.mongodb_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count                    = length(var.mongodb_ports_vpn)
  type                     = "ingress"
  from_port                = var.mongodb_ports_vpn[count.index]
  to_port                  = var.mongodb_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id        = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.mongodb.sg_id
}


##Redis security group
module "redis" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.redis_sg
  sg_description = var.redis_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "redis_vpn_ssh" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.redis.sg_id
}



##MySQL security group
module "mysql" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.mysql_sg
  sg_description = var.mysql_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id
}


##rabbitmq security group
module "rabbitmq" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.rabbitmq_sg
  sg_description = var.rabbitmq_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.rabbitmq.sg_id
}


## catalogue security group
module "catalogue" {
  #source = "../../terraform-aws-securitygroup"
  source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.catalogue_sg
  sg_description = var.catalogue_sg_description
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}


## user security group 
module "user" {
    #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.user_sg
    sg_description = var.user_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "user_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}


## cart security group
module "cart" {
    #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.cart_sg
    sg_description = var.cart_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}


## shipping security group
module "shipping" {
    #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.shipping_sg
    sg_description = var.shipping_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}


## payment shipping component
module "payment" {
      #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.payment_sg
    sg_description = var.payment_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

#Frontend ALB
module "frontend_alb" {
    #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_alb_sg
    sg_description = var.frontend_alb_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}


module "frontend" {
    #source = "../../terraform-aws-securitygroup"
    source         = "git::https://github.com/vamsi-mr/Terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg
    sg_description = var.frontend_sg_description
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}



#Backend ALB
resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_user" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend_alb.sg_id
}
