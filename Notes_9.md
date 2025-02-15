# Configuration Management with Ansible and Terraform – 08 February 2025  

## Terraform (Continue...)

### TLS Provider
- It stands for Transport Layer Security, which offers tools for managing security keys and certificates.
- It includes resources for creating private keys, certificates, and certificate requests as part of Terraform deployment.
- Another name for TLS is SSL.

### Generating an SSH key using the TLS provider
- Check the Terraform version.
- Install Terraform TLS provider.
- Create a self-signed certificate with the TLS provider.

```bash
$ mkdir tls_test
$ cd tls_test
$ nano main.tf
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
    content  = tls_private_key.generated.private_key_pem
    filename = "MyAWSKey.pem"
}
```

```bash
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
$ cat MyAWSKey.pem ## To check whether the key is created or not
```

### Upgrading Terraform Providers
- Refers to the process of updating provider plugins to their latest versions.
- There are two ways:
    - Manually update the provider versions in the Terraform configuration file.
    - Using the command `terraform init -upgrade`.

### Terraform Provisioners
- It enables the execution of scripts or commands on a local or remote machine at certain stages of the resource lifecycle.
- Stages can be `create`, `terminate`.
- Uses of Terraform Provisioners:
    - Initializing resources
    - Configuration management
    - Application deployment
    - File Transfer
    - Bootstrapping
    - Running remote commands
- Types of provisioners:
    - Local-exec Provisioner
    - Remote-exec Provisioner
    - File Provisioner
    - Chef Provisioner
    - Ansible Provisioner

### Formatting and Taint in Terraform
- Structuring and organizing the configuration files.
- The Taint command is used to mark a specific object as tainted in the Terraform state (deprecated, use `-replace`).

```bash
$ mkdir tf_test_format
$ cd tf_test_format
$ nano main.tf
```

```tf
resource "random_string" "random" {
  length      = 15
  special     = true
  min_numeric = 6
  min_special = 2
  min_upper   = 3
}
```

```bash
$ cat main.tf ## To see the unformatted version of the file
$ terraform fmt
$ cat main.tf ## To see the formatted version of the file
```

### Terraform Workspaces and CLI

- Workspaces help organize infrastructure by environments and variables within a single directory:
  - **Environment Management** - Manage multiple environments within the same configuration.
  - **State Isolation** - Maintain isolated states, preventing changes in one from affecting others.
  - **Easy Switch** - Easily switching between workspaces.
  - **Consistent Configuration**

#### Command Structure of Terraform Workspaces
- `terraform workspace list`
- `terraform workspace new <workspace_name>`
- `terraform workspace delete <workspace_name>`
- `terraform workspace show`

### Terraform CLI
- It is a tool that allows you to manage Infrastructure as Code (IaC) using HCL.

### Terraform State Command
- It is used for advanced state management, allowing us to modify the state indirectly.

### Enable Logging
- For logging purposes:
- `export TF_LOG=TRACE` (Linux)
- `$env:TF_LOG="TRACE"` (PowerShell)

### Terraform Import
- It helps add the existing resources to the configuration and bring them into the Terraform state with minimal coding and effort.

### Debugging in Terraform
- Enable Logging
- Set logging path
- Disable logging

## Generating Workspaces in Terraform

```bash
$ mkdir test_tf_workspace
$ cd test_tf_workspace
$ nano main.tf
```

```tf
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "my-aws-default-key.pem"
}

resource "random_string" "random" {
  length      = 15
  special     = true
  min_numeric = 6
  min_special = 2
  min_upper   = 3
}

# Output block to print the random value
output "random_output" {
  value = random_string.random.result
}
```

```bash
$ terraform init
$ terraform validate
$ terraform apply -auto-approve
$ ls ## To check if the key file is created
$ terraform workspace list
$ terraform workspace new DEV
$ terraform workspace list
$ terraform workspace show
$ tree terraform.tfstate.d ## To see the directory structure
$ nano main.tf
```

```tf
resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "my-aws-DEV-key.pem"
}

resource "random_string" "random" {
  length      = 15
  special     = true
  min_numeric = 6
  min_special = 2
  min_upper   = 3
}

# Output block to print the random value
output "random_output" {
  value = random_string.random.result
}
```

```bash
$ terraform apply -auto-approve
$ ls ## To check if the key file is created
$ tree terraform.tfstate.d ## To see the directory structure
$ terraform state list
$ terraform show
$ terraform workspace select default
$ terraform workspace list
$ terraform destroy -auto-approve
$ terraform workspace select default
$ terraform destroy -auto-approve
$ terraform workspace select default
$ terraform workspace delete DEV
```

