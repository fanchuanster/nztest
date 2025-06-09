## Deliverables

### * Terraform

1. manually created a bastion server in public subnet for scripts execution and test, decommissioned afterwards.
2. VPC overview - VPC, Subnets (1 public and 1 private), NAT Gateway, Internet Gateway, Route Tables, Security Groups.
   ![1749288755123](screenshots/1749287909411.png)
3. VPC details
   ![1749287827327](screenshots/1749287827327.png)
4. EC2 for nginx server in private subnet
   ![1749458212239](screenshots/1749458212239.png)

### * Ansible

1. manually added domain mapping to /etc/hosts of bastion server so that nginx server is accessible by domain name
   `echo "10.0.1.9 www.mynginux.com" | sudo tee -a /etc/hosts`
2. access the self-signed nginx server in a normal way did not work
3. access with -k allowing insecure server connections did work
4. inspect certificate and CN
   ![1749289466928](screenshots/1749289466928.png)

### * Packer

1. built nginx linux AMI - ami-0fdcaf037ff67a497. For debugging the build EC2 was in public subnet, however it can be in private subnet.
   ![1749379185953](screenshots/1749379185953.png)
2. launched an EC2 with the AMI
   ![1749379456374](screenshots/1749379456374.png)
3. verity https access and self-signed certificate
   ![1749379736420](screenshots/1749379736420.png)
4. built nginx Windows AMI - ami-0a3c8035610690748
   ![1749456826468](screenshots/1749456826468.png)
5. launched an EC2 from the Windows AMI in private subnet
   ![1749457135168](screenshots/1749457135168.png)
6. verity https access and self-signed certificate
   ![1749457684017](screenshots/1749457684017.png)
7. manually reused self-signed certificate for Windows