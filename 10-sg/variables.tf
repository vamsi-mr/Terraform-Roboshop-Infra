variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "frontend_sg_name" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
  default = "bastion"
}

variable "bastion_sg_description" {
  default = "created sg for bastion instance"
}

variable "backend_alb" {
  default = "backend-alb"
}

variable "backend_sg_description" {
  default = "created for backend load balancer"
}

variable "vpn_sg" {
  default = "vpn"
}

variable "vpn_sg_description" {
  default = "created for vpn"
}
