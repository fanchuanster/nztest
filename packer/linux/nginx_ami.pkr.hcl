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

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 16     # in GiB, increase as needed
    volume_type = "gp3"  # or "gp2"
    delete_on_termination = true
  }

  user_data = <<EOF
#!/bin/bash
# Install OpenSSH server and SFTP support
dnf install -y openssh-server openssh-clients

# Ensure SSHD is enabled and started
systemctl enable sshd
systemctl start sshd

# Symlink sftp-server where Ansible expects it
if [ ! -f /usr/lib/sftp-server ]; then
  ln -s /usr/libexec/openssh/sftp-server /usr/lib/sftp-server
fi

# Set up SSH access
mkdir -p /home/ec2-user/.ssh
echo '${var.public_key_contents}' >> /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 600 /home/ec2-user/.ssh/authorized_keys
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
    ansible_env_vars = [
      "ANSIBLE_SCP_IF_SSH=true"
    ]
  }
}
