variable "common_tags" {
  default = {
    project   = "Roboshop"
    Terraform = true
  }
}

variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "ec2_tags" {
  default = "Ansible"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "sg_name" {
  default = "allow-all-ansible"
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
  default = "allow-all-ansible"
}