# Configuration Management with Ansible and Terraform – 08 February 2025  

## Terraform (Continue...)

### TLS Provider
- It stands for Transport Layer Security, which offers tools for managing security keys and certificates.
- It includes resources for creating private keys, certificates and certificate requests as part of Terraform deployment.
- Another name for TLS is SSL
### Generating a SSH key using the TLS provider
- Check the terraform version.
- Install terraform TLS provider.
- Create a self-signed certificate with TLS provider.

```bash
$mkdir tls_test
$cd tls_test
$nano main.tf
```
```tf
terraform {
    required_version = ">= 1.0.0"
    required_providers {
        http = {
            source = "hashicorp/http"
            version = "2.1.0"
        }
        random = {
            source = "hashicorp/random"
            version = "3.6.3"
        }
        local = {
            source = "hashicorp/local"
            version = "2.5.2"
        }
        tls = {
            source = "hashicorp/tls"
            version = "4.0.6"
        }
    }
}

resource "tls_private_key" "generated" {
    algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
    content = tls_private_key.generated.private_key_pem
    filename = "MyAWSKey.pem"
}
```
```bash
$terraform init
$terraform validate
$terraform plan
$terraform apply -auto-approve
$cat MyAWSKey.pem ## To check whether key is created or not
```
### Upgrading Terraform Providers
- Refers to the process of updating provider plugins to their latest versions.
- There are two ways 
    - Manually update the provider versions in Terraform configuration file
    - Using the command `terraform init -upgrade`

### Terraform Provisioners
- It enables the execution of scripts or commands on a local or remote machine at certain stages of the resource lifecycle.
- Stages can be create , terminate.
- Uses of Terraform Provisioners
    - Initializing resources
    - Configuration management
    - Application deployment
    - File Transfer
    - Bootstrapping
    - Running remote commands
- Types of provisioners
    - Local-exec Provisioner
    - Remote-exec Provisioner
    - File Provisioner
    - Chef Provisioner
    - Ansible Provisioner
### Example of Local and Remote Exec Provisioners
```bash
$mkdir provisioners_test
$cd provisioners_test
$nano main.tf
```
```tf
# Local values - to be used during resource creation
locals {
  ami_id = "ami-0e1bed4f06a3b463d"
  ssh_user = "ubuntu"
}

# Provider section
provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region = "us-east-1"
}

# Create AWS VPC (Virtual Private Cloud)
resource "aws_vpc" "sl-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "sl-vpc"
  }
}

# Create AWS Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.sl-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch  = true
  depends_on = [aws_vpc.sl-vpc]
  tags = {
    Name = "sl-subnet"
  }
}

# Create AWS Route Table
resource "aws_route_table" "sl-route-table" {
  vpc_id = aws_vpc.sl-vpc.id
  tags = {
    Name = "sl-route-table"
  }
}

# Create AWS Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.sl-route-table.id
}

# Create AWS Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sl-vpc.id
  depends_on = [aws_vpc.sl-vpc]
  tags = {
    Name = "sl-gw"
  }
}

# Create AWS Route
resource "aws_route" "sl-route" {
  route_table_id = aws_route_table.sl-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.gw.id
}


# AWS security group resource block - 3 inbound & 1 outbound rule added
resource "aws_security_group" "sl-sg" {
  name = "sl-sg"
  vpc_id = aws_vpc.sl-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sl-sg"
  }

}

# TLS provider
resource "tls_private_key" "tls-key" {
  algorithm = "RSA"
}

# AWS Keypair with TLS
resource "aws_key_pair" "app-key" {
  key_name   = "sl-key"
  public_key = tls_private_key.tls-key.public_key_openssh
}

# Saving the key file
resource "local_file" "sl-key" {
  content  = tls_private_key.tls-key.private_key_pem
  filename = "sl-key.pem"
  file_permission = "0400"
}

# Change file permissions to 400
# resource "null_resource" "set_key_permission" {
#   provisioner "local-exec" {
#     command = "chmod 400 sl-key.pem"
#   }

#   # Ensure this runs after the local_file resource
#   depends_on = [local_file.sl-key]
# }

# AWS EC2 instance resource block
resource "aws_instance" "web" {
  ami = local.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  
  subnet_id = aws_subnet.subnet-1.id
  security_groups = [aws_security_group.sl-sg.id]
  key_name = aws_key_pair.app-key.key_name

  tags = {
    Name = "Abhi Test"
  }

  # SSH Connection block which will be used by the provisioners - remote-exec
  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    # private_key = file(local.private_key_path)
    private_key = tls_private_key.tls-key.private_key_pem
    timeout = "2m"  
  }

  # Remote-exec Provisioner Block - wait for SSH connection
  provisioner "remote-exec" {
    inline = [
      "echo 'wait for SSH connection to be ready...'",
      "touch /home/ubuntu/demo-file-from-terraform.txt"
    ]
  }

  # Local-exec Provisioner Block - create an Ansible Dynamic Inventory
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> myhosts"
  }

  # Local-exec Provisioner Block - create an Ansible Dynamic Inventory
  provisioner "local-exec" {
    command     = "echo Hello_Me > hello.txt"
    working_dir = "${path.module}/"
    interpreter = ["/bin/bash", "-c"]
  }
  
}

# Output block to print the public ip of instance
output "instance_ip" {
  value = aws_instance.web.public_ip
} 
```
```bash
$terraform init
$terraform validate
$terraform plan
$terraform apply -auto-approve
```
- Check the content of files hello.txt and myhosts in local machine
- Also check ec2 instance home directory to the file is created
```bash
$terraform destroy -auto-approve ## delete all resources created above
```
### Formatting and Tain in Terraform
- Structuring and organizing the configurationf files
- Taint command is used to makes a specific object as tainted in the Terradform state(deprecated use -replace)

```bash
$mkdir tf_test_format
$cd tf_test_format
$nano main.tf
```
```tf
resource "random_string" "random" {
  length = true
  special = true
 min_numeric = 6
    min_special = 2
         mini_upper = 3 
}
```

```bash 
$cat main.tf ## To see unformatted version of file
$terraform fmt
$cat main.tf ## To see formatted version of file
```

### Terraform Workspaces and CLI

- Workspaces help organize infrastructure by environments and variables within a single directory
  - Environment Management - Manage multiple environments within the same configuration.
  - State Isolation - Maintain isolated states, preventing changes in one from affecting other
  - Easy Switch - Easy switching between workspacess
  - Consistent configuration
#### Command Structure of Terraform Workspaces
- terraform workspace list
- terraform workspace new <workspace_name>
- terraform workspace delete <workspace_name>
- terraform workspace show 
### Terraform CLI
- It is a tool that allows you to manage IaC using HCL.
### Terraform State Command
- It is used for advanced state management allowing us to modify the state indirectly.
### Enable Logging
- For logging purposes
- export TF_LOG=TRACE (Linux)
- $env:TF_LOG="TRACE" (PowerShell)
### Terraform Import
- it helps add the existing resources to configuration and bring them into the Terraform state with minimal coding and effort.
### Debugging in Terraform
- Enable Logging
- Set logging path
- Disable logging

## Workspaces Examples



