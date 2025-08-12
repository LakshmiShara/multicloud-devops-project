variable "aws_region" { default = "us-east-1" }
variable "cluster_name" { default = "multicloud-eks" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "aws_azs" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "cluster_version" { default = "1.26" }
