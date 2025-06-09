packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region"           { default = "us-west-2" }
# variable "subnet_id"        { default = "subnet-0c02b52b8296b42bf" }
variable "subnet_id"        { default = "subnet-0a406f7f6020eb55a" }    # public subnet
variable "instance_type"    { default = "t3.large" }
variable "ami_name"         { default = "nginx-https-windows-{{timestamp}}" }
variable "winrm_username"   { default = "Administrator" }
variable "winrm_password"   { default = "RUvMEK;(gjegc?VkYrcG.-4vV@u3x$rg" }
variable "domain_name"      { default = "www.mynginx.com" }
variable "base_amazon_ami_name_filter"      { default = "Windows_Server-2019-English-Full-Base-*" }

source "amazon-ebs" "windows" {
  region                      = var.region
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  ami_name                    = var.ami_name
  communicator                = "winrm"
  winrm_username              = var.winrm_username
  winrm_password              = var.winrm_password
  winrm_use_ssl               = false
  security_group_id           = "sg-0295e3e293c567d68"
  associate_public_ip_address = true
  user_data_file              = "scripts/user_data.bat"

  source_ami_filter {
    filters = {
      name                = var.base_amazon_ami_name_filter
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["801119661308"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.windows"]

  # Upload nginx.conf.j2 template
  provisioner "file" {
    source      = "templates/nginx.conf.j2"
    destination = "C:\\tmp\\nginx.conf.j2"
  }

  # Upload index.html template
  provisioner "file" {
    source      = "../../ansible/roles/nginx/files/index.html"
    destination = "C:\\tmp\\index.html"
  }

  provisioner "file" {
    source      = "certs/selfsigned.crt"
    destination = "C:\\tmp\\selfsigned.crt"
  }

  provisioner "file" {
    source      = "certs/selfsigned.key"
    destination = "C:\\tmp\\selfsigned.key"
  }

  provisioner "powershell" {
    inline = [
      # Install Nginx
      "Invoke-WebRequest -Uri https://nginx.org/download/nginx-1.24.0.zip -OutFile C:\\tmp\\nginx.zip",
      "Expand-Archive -Path C:\\tmp\\nginx.zip -DestinationPath C:\\tmp",
      "Move-Item -Path C:\\tmp\\nginx-* -Destination C:\\nginx",
      "New-Item -Path C:\\nginx\\certs -ItemType Directory -Force",

      # Render nginx.conf from template
      "$template = Get-Content -Path C:\\tmp\\nginx.conf.j2 -Raw",
      "$config = $template -replace '\\{\\{\\s*domain_name\\s*\\}\\}', '${var.domain_name}'",
      "Set-Content -Path C:\\nginx\\conf\\nginx.conf -Value $config",

      # Render index.html
      "Copy-Item -Path C:\\tmp\\index.html -Destination C:\\nginx\\html\\index.html ",

      # Deploy self-signed certificate
      "Copy-Item -Path C:\\tmp\\selfsigned.key -Destination C:\\nginx\\certs\\cert.key",
      "Copy-Item -Path C:\\tmp\\selfsigned.crt -Destination C:\\nginx\\certs\\cert.crt",

      # Open firewall for HTTPS
      "New-NetFirewallRule -DisplayName 'Allow HTTPS' -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow",

      # Download and install NSSM
      "Invoke-WebRequest -Uri https://nssm.cc/release/nssm-2.24.zip -OutFile C:\\tmp\\nssm.zip",
      "Expand-Archive -Path C:\\tmp\\nssm.zip -DestinationPath C:\\tmp",
      "Move-Item -Path C:\\tmp\\nssm-* -Destination C:\\nssm",

      # Install Nginx as a Windows service using NSSM
      "C:\\nssm\\win64\\nssm.exe install nginx C:\\nginx\\nginx.exe",
      "Set-Service -Name nginx -StartupType Automatic",
      "Start-Service -Name nginx"
    ]
  }
}
