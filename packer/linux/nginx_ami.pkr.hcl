
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "source_ami" {
  type    = string
  default = "ami-0418306302097dbff"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_keypair_name" {
  type    = string
  default = "ops-key"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

variable "ami_name" {
  type    = string
  default = "nginx-https-linux-{{timestamp}}"
}

source "amazon-ebs" "nginx-linux" {
  region                  = var.region
  source_ami              = var.source_ami
  instance_type           = var.instance_type
  ssh_username            = var.ssh_username
  key_pair_name           = var.ssh_keypair_name
  ami_name                = var.ami_name
  associate_public_ip_address = false
}

build {
  name    = "nginx-linux-ami"
  sources = ["source.amazon-ebs.nginx-linux"]

  provisioner "ansible" {
    playbook_file = "../../ansible/playbook.yml"
    extra_arguments = ["-e", "ansible_python_interpreter=/usr/bin/python3"]
  }
}