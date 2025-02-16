# Configuration Management with Ansible and Terraform

## Terraform Security Tools and Best Practices

### Tools
- **Checkov** – A static code analysis tool for detecting misconfigurations (free version available).  
- **TFSec** – A static code scanner for identifying best practice violations and vulnerabilities (free version available).  
- **Sentinel** – A policy enforcement tool that allows you to define and enforce policies within the Terraform ecosystem (free version available).  

## Best Practices for Securing Terraform
- Secure state files.  
- Conduct code reviews.  
- Use Sentinel for policy enforcement.

## Manage Secrets and Crdentials in Terraform
```sh
$ mkdir security01
$ cd security01
$ nano main.tf
```
```tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  tags = {
    Name = "MyMachine"
  }
}
```
```sh
## Terraform is using the AWS CLI behind the scene so we can set the AWS secret key and access key using aws configure command then we do not need to provide the secrets inside the configuration file which is treat.
$ sudo apt update -y
$ sudo apt install -y awscli
$ aws configure
## Please provide the Access Key and secret key here.
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply --auto-approve
## Please check the AWS console.
```