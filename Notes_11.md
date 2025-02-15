# Configuration Management with Ansible and Terraform – 15 February 2025 

## Read, Generate and Modify Configurations
- Data Block - used to provide data to resources which will collect information from aws
- Initializing the configuration
- Validate the configuration
  - Valid Message
  - if it is not valid, it will through the errors
- Planning the changes
- Applying the configuration
- Managing the state
- Modifying and Iterating (designed to update the infrastructure incrementaly)
- Destroying the infrastructure
## Variables and Ouputs
- Input variables (variable blocks)
(attributes are)
  - default
  - type
  - description
  - validation
  - sensitive
- Output values (Output blocks)
  - Referred to as outputs
- Local Values (Local block)

### Accessing the child 
`module.<MODULE_NAME>.<OUTPUT_NAME>`
### Local Values
- A local value associates a name with expression, allowing users to reuse the name multiple times within a module instead of duplicating the expression.
- Local values are like a function's temporary local variables.
```tf
locals {
  service_name = 'ec2'
}
```
- to reduce duplication
- simplifying complex expressions
- faciliating future changes

## Advanced Variable Management
### Custom Validation Rules
- Users can specify custom validation
- introduced in Terraform v0.13.0
- Usage
```tf
variable "image"{
    validation { 
      condition = '' 
      error_message = ''
    }
}
```
### Supressing values
- Using the attribute `sensitive`
- it prevent its value from appearing in output
### Securing Secrets in Terraform code
- `sensitive` data flag
- Use environment variables
```bash
export TF_VAR_secret_key = "value"

## use
variable "secret_key" {}
```
- Use terraform vault provider
```tf
provider "vault" {}
```
- Encrypt state files using the keyword `encrypt`
- Use least privilege access
- Audit and rotate secrets regularly



