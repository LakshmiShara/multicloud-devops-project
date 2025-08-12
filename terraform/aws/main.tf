terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"
  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr
  azs = var.aws_azs
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  node_groups = {
    ng-default = {
      desired_capacity = 2
      max_capacity = 3
      min_capacity = 1
      instance_type = "t3.medium"
    }
  }
}

output "aws_kubeconfig" {
  value = module.eks.kubeconfig
}
