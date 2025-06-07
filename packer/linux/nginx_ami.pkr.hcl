# packer/linux/nginx_ami.pkr.hcl

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "subnet_id" {
  type  = string
}

variable "source_ami" {
  type    = string
  default = "ami-0418306302097dbff"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_name" {
  type    = string
  default = "nginx-https-linux-{{timestamp}}"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

variable "ssh_private_key_file" {
  type = string
}

variable "public_key_contents" {
  type = string
}

variable "domain_name" {
  type    = string
}

source "amazon-ebs" "nginx-linux" {
  region                     = var.region
  subnet_id                  = var.subnet_id
  source_ami                 = var.source_ami
  instance_type              = var.instance_type
  ssh_username               = var.ssh_username
  ssh_private_key_file       = var.ssh_private_key_file
  ami_name                   = var.ami_name
  associate_public_ip_address = false

    user_data = <<EOF
#!/bin/bash
# Install SSH and SFTP support
sudo dnf install -y openssh-server openssh-clients

# Add symlink for sftp-server for Ansible compatibility
sudo mkdir -p /usr/lib
sudo ln -s /usr/libexec/openssh/sftp-server /usr/lib/sftp-server

# Start and enable SSH
sudo systemctl enable sshd
sudo systemctl start sshd

# Configure ec2-user SSH
mkdir -p /home/ec2-user/.ssh
echo '${var.public_key_contents}' >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys

# Fix for Ansible: temp dirs and permissions
mkdir -p /home/ec2-user/.ansible/tmp
chown -R ec2-user:ec2-user /home/ec2-user/.ansible
chmod 700 /home/ec2-user/.ansible/tmp
EOF

}

build {
  name    = "nginx-linux-ami"
  sources = ["source.amazon-ebs.nginx-linux"]

  provisioner "ansible" {
    playbook_file   = "../../ansible/playbook.yml"
    extra_arguments = [
        "-e", "ansible_python_interpreter=/usr/bin/python3",
        "-e", "domain_name=${var.domain_name}"
    ]
  }
}
