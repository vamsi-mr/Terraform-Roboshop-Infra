resource "aws_instance" "bastion" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id
  iam_instance_profile = "TerraformAdmin"  ## no need to configure aws again in bastion

user_data = <<-EOF
            #!/bin/bash
            yum install yum-utils -y
            yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            yum install terraform -y
            EOF

# need more for terraform
root_block_device {
    volume_size = 10
    volume_type = "gp3" # or "gp2", depending on your preference
  }


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-bastion"
    }
  )
}

