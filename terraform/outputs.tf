output "vpc_info" {
  description = "VPC and subnet IDs"
  value = {
    vpc_id             = module.vpc.vpc_id
    public_subnet_id   = module.vpc.public_subnet_id
    private_subnet_id  = module.vpc.private_subnet_id
  }
}

output "ec2_info" {
  description = "EC2 instance and security group IDs"
  value = {
    instance_id        = module.ec2.instance_id
  }
}