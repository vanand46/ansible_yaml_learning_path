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
- ### Alternative Approach
```sh
$ mkdir security02
$ cd security02
$ nano main.tf
$ nano credentials.tf
```
```tf 
## main.tf
resource "aws_instance" "web" {
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  tags = {
    Name = "MyMachine02"
  }
}

```
```tf 
## credentials.tf
provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region = "us-east-1"
}

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
```
- Set the environment variables
```sh
$ export TF_VAR_AWS_ACCESS_KEY=aws_access_key
$ export TF_VAR_AWS_SECRET_KEY=aws_secret_key
```

```sh
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply --auto-approve
```

- ### Checkov(tool) Validation Example
```sh
## Install Checkov
$ pip install checkov
$ which checkov
$ checkov -f credentials.tf 
```

## Terraform Cloud
- A platform by HashiCorp that helps manage Terraform code.
- Facilitates collaboration between developers.
- Enables audit logging and continuous validation.
- Provides secure access to shared state.
- Implements robust controls.
- Offers a private registry.
- Key Terms
  - Workspaces
  - Secure Variables
  - Terraform Variables
  - Version Control System (GitHub, Gitlab,  Github App for TFE)

### Cloud Example
- Login to Github account
- Login Terraform cloud: app.terraform.io

```sh
$ mkdir tfcloud_test
$ cd tfcloud_test
```

- Create a new TF Cloud workspace
- Choose the organization > Workspaces > New > Workspace
- Select - Default project > Create
- Choose CLI driven workflow
  - Workspace name: demo_testws_01
  - Create
```sh
$ terraform login
## provide token and login
$nano main.tf
```
```tf
  terraform {
    cloud {
      organization = "demo_org_avg"

      workspaces {
        name = "demo_cloud_ws"
      }
    }
  }

  variable "my_string" {
    description = "My string input variable"
    type        = string
  }


  variable "listofstrings" {
    type    = list(string)
    default = ["my-string-1", "my-string-2", "my-string-3"]
  }

  variable "iplist" {
    type = map(string)
    default = {
      prod = "100.100.100.100",
      dev  = "200.200.200.200"
    }
  }

  variable "env" {
    type = map(any)
    default = {
      prod = {
        ip  = "100.100.100.100",
        loc = "us"
      },
      dev = {
        ip  = "200.200.200.200",
        loc = "in"
      }
    }
  }

  output "print_string_var" {
    value = var.my_string
  }

  output "print_full_list" {
    value = var.listofstrings
  }

  output "print_first_list_item" {
    value = var.listofstrings[0]
  }

  output "print_prod_ip" {
    value = var.iplist["prod"]
  }

  output "print_prod_env" {
    value = [var.env.prod.ip, var.env.prod.loc]
  }

  output "print_dev_env" {
    value = [var.env.dev.ip, var.env.dev.loc]
  }
```
```sh
$ terraform init
## Set the variables using terraform cloud workspace variables
$ terraform validate
$ terraform apply --auto-approve
```



