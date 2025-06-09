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

  pause_before_connecting = "5s"
  temporary_key_pair_name = "debug-key" # Optional, to keep a reusable key name

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 8     # in GiB, increase as needed
    volume_type = "gp3"  # or "gp2"
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
dnf update -y
dnf install -y openssh-server curl
systemctl enable sshd
systemctl start sshd

# Fix SFTP for Ansible SCP
# ln -s /usr/libexec/openssh/sftp-server /usr/lib/sftp-server || true

mkdir -p /home/${var.ssh_username}/.ssh
echo '${var.public_key_contents}' >> /home/${var.ssh_username}/.ssh/authorized_keys
chown -R ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/.ssh
chmod 600 /home/${var.ssh_username}/.ssh/authorized_keys

mkdir -p /home/${var.ssh_username}/.ansible/tmp
chown -R ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/.ansible
chmod -R 700 /home/${var.ssh_username}/.ansible

EOF

}

build {
  name    = "nginx-linux-ami"
  sources = ["source.amazon-ebs.nginx-linux"]

  provisioner "ansible" {
    playbook_file   = "../../ansible/playbook.yml"
    user            = var.ssh_username
    use_proxy       = false     # workaround file transfer failure with local proxy
    extra_arguments = [
        "-e", "ansible_python_interpreter=/usr/bin/python3",
        "-e", "domain_name=${var.domain_name}"
    ]
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_STDOUT_CALLBACK=debug"

    ]
  }
}
