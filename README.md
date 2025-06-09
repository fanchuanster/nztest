## Deliverables

### * Terraform

1. manually created a bastion server in public subnet for scripts execution and test
2. VPC overview - VPC, Subnets, NAT Gateway, Internet Gateway, Route Tables, Security Groups.
   ![1749288755123](screenshots/1749287909411.png)
3. VPC details
   ![1749287827327](screenshots/1749287827327.png)
4. EC2 for nginx serve
   ![1749288755123](screenshots/1749288755123.png)

### * Ansible

1. manually added domain mapping to /etc/hosts of bastion server so that nginx server is accessible by domain name
   `echo "10.0.1.9 www.mynginux.com" | sudo tee -a /etc/hosts`
2. access the self-signed nginx server in a normal way did not work
3. access with -k allowing insecure server connections did work
4. inspect cert and CN![1749289466928](screenshots/1749289466928.png)

### * Packer
1. built nginx linux AMI - ami-0fdcaf037ff67a497
![1749379185953](screenshots/1749379185953.png)
2. launched an EC2 with the AMI
![1749379456374](screenshots/1749379456374.png)
3. verity https access and self-signed certificate
![1749379736420](screenshots/1749379736420.png)
