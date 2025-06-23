variable "common_tags" {
  default = {
    project   = "Roboshop"
    Terraform = true
  }
}

variable "ami_id" {
  type        = string
  default     = "ami-09c813fb71547fc4f"
  description = "AMI ID of join devops RHEL9"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instances" {
  default = ["Frontend", "MongoDB", "Catalogue", "Redis", "User", "Cart", "MySQL", "Shipping", "RabbitMQ", "Payment"]
}

variable "sg_name" {
  default = "allow-all"
}

variable "sg_description" {
  default = "Allowing all traffic"
}

variable "from_port" {
  default = 0
}

variable "to_port" {
  default = 0
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "sg_tags" {
  default = "allow-all"
}

variable "zone_id" {
  default = "Z06734122W0TQFHN7RZBR"
}

variable "domain_name" {
  default = "ravada.site"
}