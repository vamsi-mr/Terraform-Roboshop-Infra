variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
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

variable "mongodb_sg" {
  default = "mongodb"
}

variable "mongodb_sg_description" {
  default = "created for mongodb"
}

variable "mongodb_ports_vpn" {
  default = ["22", "27017"]
}

variable "mongodb_ports_bastion" {
  default = ["22", "27017"]
}

variable "redis_sg" {
  default = "redis"
}

variable "redis_sg_description" {
  default = "created for redis db"
}

variable "redis_ports_vpn" {
  default = ["22", "6379"]
}

variable "redis_ports_bastion" {
  default = ["22", "6379"]
}

variable "mysql_sg" {
  default = "mysql"
}

variable "mysql_sg_description" {
  default = "created for mysql db"
}

variable "mysql_ports_vpn" {
  default = ["22", "3306"]
}

variable "mysql_ports_bastion" {
  default = ["22", "3306"]
}

variable "rabbitmq_sg" {
  default = "rabbitmq"
}

variable "rabbitmq_sg_description" {
  default = "created for rabbitmq db"
}

variable "rabbitmq_ports_vpn" {
  default = ["22", "5672"]
}

variable "rabbitmq_ports_bastion" {
  default = ["22", "5672"]
}

variable "catalogue_sg" {
  default = "catalogue"
}

variable "catalogue_sg_description" {
  default = "created for catalogue instances"
}

variable "user_sg" {
  default = "user"
}

variable "user_sg_description" {
  default = "created for user component"
}

variable "cart_sg" {
  default = "cart"
}

variable "cart_sg_description" {
  default = "created for cart component"
}

variable "shipping_sg" {
  default = "shipping"
}

variable "shipping_sg_description" {
  default = "created for shipping component"
}

variable "payment_sg" {
  default = "payment"
}

variable "payment_sg_description" {
  default = "created for payment component"
}

variable "frontend_alb_sg" {
  default = "frontend-alb"
}

variable "frontend_alb_sg_description" {
  default = "created for frontend-alb component"
}

variable "frontend_sg" {
  default = "frontend"
}

variable "frontend_sg_description" {
  default = "created sg for frontend instance"
}