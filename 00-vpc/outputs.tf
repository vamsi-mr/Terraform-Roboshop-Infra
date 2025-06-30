# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "public_subnet_ids" {
#   value = module.vpc.public_subnet_ids
# }


# $ for i in 00-vpc/ 10-sg/ 20-bastion/ 30-vpn/ 40-databases/ 50-backend-alb/ ; do cd $i; terraform apply -auto-approve; cd .. ; done