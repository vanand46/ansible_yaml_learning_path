# Configuration Management with Ansible and Terraform 

## Infrastructure as Code  
- It is a practice followed by IT companies to improve infrastructure deployments, increase users' ability to scale quickly, and improve the application development process.  
- It automates the provisioning of development and production environments.  
- Ensures disaster recovery.  
- Manages scalable infrastructure.  
- Maintains consistent configurations to prevent drift.  
- Ensures security policies and compliance.  

### Benefits  
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
- SaltStack  
- Vagrant  
- Pulumi  

## Terraform: Driving Multi-Cloud Deployments with IaC  
- It is an IaC tool that enables users to construct, modify, and version infrastructure securely and efficiently.  
- Uses a declarative configuration approach.  

### Roles  
- Automation  
- Scalability  
- Integration with CI/CD  
- State management  
- Version control  

### Features  
- IaC  
- Execution Plans  
- State Management  
- Declarative Configuration  

### Terraform Lifecycle  
- Init - Initializing working directory into a Terraform module.  
- Plan - Execution plan to reach the desired state.  
- Apply - Applying changes to the infrastructure.  
- Destroy - Deleting all the provisioned resources using Terraform.  

### Terraform Workflow  
- Write the infrastructure configuration file (.tf).  
- Plan the execution file.  
- Apply the execution file.  

### Terraform Architecture  
- Terraform core - Binary (Go Programming Language).  
- State file.  
- Providers (APIs to communicate with different clouds).  
- Provisioners.  

### Benefits  
- Improved collaboration.  
- Consistency.  
- Reusability.  
- Portability across clouds.  
- Reduced development costs.  

### Terraform Blocks  
- **Provider Block** - Specifies a cloud platform and authentication.  
- **Resource Block** - Defines infrastructure components with configurations.  
- **Variable Block** - Declares variables for configuration.  
- **Output Block** - Displays values after deployment.  
- **Data Block** - Fetches external data.  

### CloudFormation  
- A service provided by AWS to manage cloud resources.  

## HashiCorp Configuration Language (HCL)  
- A declarative configuration language.  
- Structured.  
- Uses expressions.  
- Supports templating.  
- Primarily used for defining configurations for provisioning and managing infrastructure resources.  

### HCL Syntax  
- Blocks and nesting.  
- Attributes and values.  
- Variables.  
- Expressions.  
- Quoted strings.  
- Comments.  
- Dynamic Blocks.  

### HCL Basic Syntax  
- Blocks.  
- Arguments.  
- Expressions.  
- Identifiers:  
    - Argument names.  
    - Block type names.  
    - Terraform-specific entities.  
    - Must start with letters.  
    - Case-sensitive.  
    - Cannot contain special characters or spaces (_ is allowed).  

## EC2 Setup  

```bash
# Launch EC2 instance using the Management Console:
> Log in to your AWS Management Console.
> Switch to the us-east-1 region.
> Go to EC2 > Instances > Launch Instances.
  - Name: Abhi Instance 01
  - AMI: Ubuntu 22.04 (ami-0e1bed4f06a3b463d)
  - Instance Type: t2.micro
  - Key pair: Create a new key pair.
      - Key pair name: demo_key
      - Key pair type: RSA
      - Private key file format: .pem
  - Network settings: KEEP DEFAULT
  > Launch Instance

# SSH into the EC2 instance:
$ chmod 400 "demo_key.pem"
$ ssh -i "demo_key.pem" ubuntu@INSTANCE_PUBLIC_IP/PUBLIC_DNS_NAME
$ ssh -i "demo_key.pem" ubuntu@54.146.174.190
# exit
```

## Hands-On - HashiCorp Configuration Language  

```bash
$ terraform -version

$ cd 
$ mkdir tf_s3
$ cd tf_s3

$ nano main.tf
```

```tf
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
```

```bash
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply
```

- Go to AWS S3 and check whether the bucket has been created.  

```bash
$ terraform destroy -auto-approve
```

- Go to AWS S3 and check whether the bucket has been deleted.  

### HCL Functions  

```bash
$ mkdir tf_functions
$ cd tf_functions/
$ nano main.tf
```

```tf
variable "greeting" {
  default = "Hello"
}

variable "list_example" {
  default = ["one", "two", "three"]
}

variable "name" {
  default = "World"
}

variable "map_example" {
  default = {
    key1 = "Value1"
    key2 = "Value2"
  }
}

output "greet_message" {
  value = "${var.greeting}, ${upper(var.name)}"
}

output "first_list_item" {
  value = element(var.list_example, 0)
}

output "map_value" {
  value = lookup(var.map_example, "key1")
}

output "base64_encode" {
  value = base64encode(var.name)
}
```

```bash
$ terraform init
$ terraform validate
$ terraform apply -auto-approve
```

## Terraform Basics and Workflows  

## Providers  
- Plugins that enable Terraform to manage resources across various platforms, including cloud services, container tools, databases, and other APIs.  
- [Terraform Registry](https://registry.terraform.io/) supports:  
  - Azure  
  - AWS  
  - Kubernetes  
  - Google Cloud  
  - Alibaba Cloud  
  - Oracle Cloud  
  - VMware vSphere  

### Role of Providers  
- Provide resource types and data sources.  
- Implement each resource type, making them essential for Terraform's functionality.  

### Running Multiple Terraform Providers  
- Improved reliability.  
- Cost optimization.  
- Performance optimization.  
- Enhanced security and compliance.  
- Innovation and flexibility.  
- Strategic benefits.  

```bash
$ mkdir tf_multiprovider
$ cd tf_multiprovider/
$ nano main.tf
```

```tf
terraform {
    required_version = ">=1.0.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.86.1"
        }
        random = {
            source = "hashicorp/random"
            version = "3.6.3"
        }
    }
}
```

```bash
$ terraform providers
```

```bash
$ nano main_aws.tf
```

```tf
provider "aws" {
  access_key = "aws-access_key"
  secret_key = "aws-secret_key"
  region = "us-east-1"
  alias = "us_east_1"
}

provider "aws" {
  access_key = "aws-access_key"
  secret_key = "aws-secret_key"
  region = "us-east-2"
  alias = "us_east_2"
}

resource "aws_instance" "example_us_east_1" {
  provider = aws.us_east_1
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example" {
  provider = aws.us_east_2
  bucket = "my-unique-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
```

```bash
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
```

```bash
$ terraform destroy -auto-approve
```

- Go to AWS and check whether the S3 bucket and EC2 instance have been deleted.  
