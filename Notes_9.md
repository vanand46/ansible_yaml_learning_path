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
