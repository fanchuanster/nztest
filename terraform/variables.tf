variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnets"
  type        = string
}

variable "base_amazon_ami_name_filter" {
  description = "Base amazon ami name filter"
  type        = string
  default     = "al2023-ami-kernel-default-x86_64"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "SSH key name to associate with EC2"
  type        = string
}
