module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = format("%s-vpc", var.eks_name)
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  # enable_vpn_gateway = true  NÃO SERA USADO. TIRAR E EXPLICAR

  tags = {
    FIAP = "TechChallenge"
  }

private_subnets_tags = {
    "Name" = format("%s-sub-private", var.eks_name), # Definir o nome 
    "kubernetes.io/role/internal-elb" = 1, # Nas subnets privadas, vão ser criados loadbalancer interno.
    "kubernetes.io/cluster/${var.eks_name}" = "shared" # Subnet compartilhada com esse cluster.
}

public_subnets_tags = { #Trabalhar com loadbalancer público
    "Name" = format("%s-sub-public", var.eks_name), 
    "kubernetes.io/role/elb" = 1, 
    "kubernetes.io/cluster/${var.eks_name}" = "shared" 
}


}