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
}

variable "subnet_id" {
  type  = string
}

variable "source_ami" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "ami_name" {
  type    = string
}

variable "ssh_username" {
  type    = string
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

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 16     # in GiB, increase as needed
    volume_type = "gp3"  # or "gp2"
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y openssh-server curl
systemctl enable ssh
systemctl start ssh

mkdir -p /home/ubuntu/.ssh
echo '${var.public_key_contents}' >> /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
EOF

}

build {
  name    = "nginx-linux-ami"
  sources = ["source.amazon-ebs.nginx-linux"]

  provisioner "ansible" {
    playbook_file   = "../../ansible/playbook.yml"
    user            = var.ssh_username
    extra_arguments = [
        "-e", "ansible_python_interpreter=/usr/bin/python3",
        "-e", "domain_name=${var.domain_name}"
    ]

    ansible_env_vars = [
      "ANSIBLE_STDOUT_CALLBACK=debug",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s'",
      "ANSIBLE_NOCOLOR=True"
    ]
    ansible_ssh_extra_args = [
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa"
    ]
  }
}
