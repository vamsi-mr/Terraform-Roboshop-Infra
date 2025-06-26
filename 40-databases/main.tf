resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-mongodb"
    }
  )
}

resource "terrafrom_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }

  provisioner "file" {
    source      = bootstrap.sh
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}
