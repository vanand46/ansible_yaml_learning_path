# Configuration Management with Ansible and Terraform – 02 February 2025  

## Infrastructure as Code
- It is a practice followed by IT companies to improve infrastructure deployments, increase user's ability to scale quickly, and improve the application development process
- It automates the provisioning of development and production environments
- Ensures disaster recovery
- Manage the scalable infrastructure
- Maintain consistent configurations to prevent drift
- Ensures Security policies and compliance
### Benifits
- Consistency
- Automation
- Version Control
- Reusability
- Testing and Validation
- Documentation 
- Cost optimization
- Scalability
### IaC Tools
- AWS CloudFormation
- Puppet
- Ansible
- Terraform
- Chef
- Azure Resource Manager
- Saltstack
- Vagrant
- Pulumi

## Terraform: Driving Multi-Cloud Deployments with IaC
- It is an IaC tool that enables users to construct ,modify and version infrastructure securely and efficiently
- Declarative configuration approach

### Roles
- Automation
- Scalability
- Integration with CI/CD
- State management
- Version Control
### Features
- IaC
- Execution Plans
- State Management
- Declarative Configuration
### Terraform Lifecycle
- Init - initializing working directory into a terrform module
- Plan - execution plan to reach the desired state
- Apply - applying to changes to the infrastructure 
- Destroy - delete all the provisioned resources by the terraform
### Terraform Workflow
- Write infrastructure configuration file (.tf)
- Plan the execution file
- Apply the execution file
### Terraform Architecture
- Terraform core - binary (Go Programming Language)
- State file
- Providers (API to communicate with different cloud)
- Provisioners
### Benefits
- Improved collaboration
- Consistency
- Reusability
- Portable across Cloud
- Reduced development cost
### Terraform Blocks
- Provider Block - specifies a cloud platform and authentication 
- Resource block - define infra components with configurations
- Variable block - declare variables for configurtion
- Output block - values displayed after deployment
- Data block - external data.
### Cloudformation
- service provided by AWS to manage their cloud services

## HashiCorp Configuration Language (HCL)
- Declarative configuration language
- Structrural
- Expression
- Template
- Primarly used for defining configurations for provisioning and managing infrastructure resources
### HCL Syntax
- Blocks and nesting
- Attributes and values
- Variables
- Expressions
- Quoted strings
- Comments
- Dynamic Blocks
### HCL Basic Syntax
- Blocks
- Arguments
- Expressions
- Identifiers
    - Argument Names
    - Block Type Names
    - Terrform specific entities
    - It should start with letters
    - Case sensitive
    - Cannot contain special characters and space (_ included)

- EC2 Setup
```bash
Launch EC2 instance - using Management Console:
> Login to your AWS Management Console
> Switch to us-east-1 region
> Goto EC2 > Instances > Launch Instances
  - Name: Abhi Instance 01
  - AMI: Ubuntu 22.04 (ami-0e1bed4f06a3b463d)
  - Instance Type: t2.micro
  - Key pair: Create new key pair
      - Key pair name: demo_key
      - Key pair type: RSA
      - Private key file format: .pem
  - Network settings: KEEP DEFAULT
  > Launch Instance


SSH into the EC2 instance:

$ chmod 400 "demo_key.pem"
$ ssh -i "demo_key.pem" ubuntu@INSTANCE_PUBLIC_IP/PUBLIC_DNS_NAME
$ ssh -i "demo_key.pem" ubuntu@54.146.174.190
# exit
```
## Hands On - Hashicorp Configuration Language:

```bash
$ terraform -version

$ cd 
$ mkdir tf_s3
$ cd tf_s3


$ nano main.tf
provider "aws" {
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply
```
- Please go to AWS s3 and check whether bucket has created or not
```bash
$ terraform destroy -auto-approve
```
- Please go to AWS s3 and check whether bucket has deleted or not

