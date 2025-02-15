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

## Variable Collections and Structure Types Terraform
- Primitive Types
  - String
  - Number
  - Bool
- Complex Types
  - List
  - Tuple
  - Set
  - Map
## Indices and Attributes
- Dot seperated notation
- Square bracket index notation  
## Type Conversion
- Terraform facilitate flexible type conversions.
- Automatic conversion like `JS`
- If it can not handle conversion, it will throw the mismatch error
- tostring(), tonumber()
 ## Terraform Variables, Validation , Data Examples
 ```bash
$ mkdir test_var
$ cd test_var
$ nano variables.tf
 ```
 ```tf
# Validation for cloud provider choice
variable "cloud" {
  type        = string
  description = "Enter the cloud provider name (aws, azure, gcp, vmware)"

  validation {
    condition     = contains(["aws", "azure", "gcp", "vmware"], lower(var.cloud))
    error_message = "Only aws, azure, gcp, and vmware are accepted as cloud providers."
  }

  validation {
    condition     = lower(var.cloud) == var.cloud
    error_message = "The cloud provider name must be in lowercase."
  }
}

# Variable for no capital letters
variable "no_caps" {
  type        = string
  description = "Enter a lowercase string."

  validation {
    condition     = lower(var.no_caps) == var.no_caps
    error_message = "The string must be in lowercase."
  }
}

# Variable with character limit
variable "character_limit" {
  type        = string
  description = "Enter a string of exactly 3 characters."

  validation {
    condition     = length(var.character_limit) == 3
    error_message = "This variable must contain exactly 3 characters."
  }
}

# IP address validation
variable "ip_address" {
  type        = string
  description = "Enter a valid IP address."

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address))
    error_message = "The input must be a valid IP address in the form X.X.X.X."
  }
}

# Sensitive data variable
variable "phone_number" {
  type        = string
  description = "Enter a sensitive phone number."
  sensitive   = true
}

# List data variable
variable "my_az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
}

# Map data variable
variable "my_ips" {
  type = map(string)
  default = {
    prod = "10.0.150.0/24",
    dev  = "10.0.250.0/24"
  }
}

# List of servers
variable "servers" {
  description = "A list of server names"
  type        = list(string)
  default     = ["server1", "server2", "server3"]
}
 ```
```bash
$nano main.tf
```
```tf
# Managing sensitive information with locals 
locals {
  contact_info = {
    cloud        = var.cloud
    department   = var.no_caps
    cost_code    = var.character_limit
    phone_number = var.phone_number
  }
}

output "cloud" {
  value = local.contact_info.cloud
}

output "department" {
  value = local.contact_info.department
}

output "cost_code" {
  value = local.contact_info.cost_code
}

output "phone_number" {
  description = "A sensitive output of the phone number"
  value       = local.contact_info.phone_number
  sensitive   = true
}

output "my_az_list_item" {
  description = "Getting the first az item"
  value       = var.my_az_list[0]
}

output "get_my_ips" {
  description = "Getting the ip item based on key"
  value       = var.my_ips["prod"]
}

# Iteration using foreach
resource "null_resource" "foreach_example" {
  for_each = toset(var.servers)

  provisioner "local-exec" {
    command = "echo ${each.value} is being provisioned"
  }
}

output "server_names" {
  value = [for server in null_resource.foreach_example : server.id]
}


# Iteration using count
resource "null_resource" "count_example" {
  count = length(var.servers)

  provisioner "local-exec" {
    command = "echo ${var.servers[count.index]} is being provisioned"
  }
}

output "server_names_count" {
  value = [for i in range(length(var.servers)) : null_resource.count_example[i].id]
}
```
```bash
$ terraform init
$ terraform validate
$ terraform plan
##
##character_limit = abhi
##cloud = abhi
##ip_address = 22.22.22.22
##no_caps = Abhi
##phone_number = 12345
##
```
```bash
##
##character_limit = dev
##cloud = aws
##ip_address = 22.22.22.22
##no_caps = abhi
##phone_number = 12345
##
$ terraform apply -auto-approve
$ terraform output ## only output contents
$ terraform output phone_number
```
## Block and Functions
### Data Block
- Data sources in Terraform are special configurations allows you to pull data from various external resources.
- Using data block to use the external data resources information\
- most_recent, owners and tags
### Data Resources and Managed Resources
- Data Resources - Read Only
- Managed Resources  - handled by terraform
- Data Source Arguments
  - meta-arguments
- Data Resource Dependencies
  - depends_on
### Terraform Built-in Functions
- Offers bunch of built in functions
- Example `max(5, 12, 9)`

## Dynamic Blocks
- powerful way to dynamically generate repeatable nested configuration blocks within resources
- Elements of Dynamic Block
  - Label
  - for_each
  - Content
  - Iterator
  - Label arguments
- Constraints
  - Integration
  - Meta-arguments (can not use meta arguments or provisioner)  
  - Complex Collections
- Multi-Level Nested Block Structures
- Configuration file will be shorter
- Considerations
  - Iterator Symbols
  - Naming and Scope 
  ```bash
  $mkdir dynamic_block
  $cd dynamic_block
  $nano main.tf
  ```
  ```tf
  #Configure the AWS provider
  provider "aws" {
    # Replace with your actual AWS credentials
    access_key = "YOUR_ACCESS_KEY"
    secret_key = "YOUR_SECRET_KEY"
    region     = "us-east-1" # Replace with your desired region
  }

  resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "MyVPC"
    }
  }

  locals {
    ingress_rules = {
      ssh = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      http = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }


  resource "aws_security_group" "dynamic_sg" {
    name   = "dynamic-sg"
    vpc_id = aws_vpc.my_vpc.id

    dynamic "ingress" {
      for_each = local.ingress_rules
      content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
      }
    }

    #ingress {
    #  from_port = 22
    #  to_port = 22
    #  protocol = "tcp"
    #  cidr_blocks = ["0.0.0.0/0"]
    #}

    #ingress {
    #  from_port = 80
    #  to_port = 80
    #  protocol = "tcp"
    #  cidr_blocks = ["0.0.0.0/0"]
    #}
  }

  locals {
    instance_suffix = "001"
  }

  resource "aws_subnet" "my_subnet" {
    vpc_id            = aws_vpc.my_vpc.id # Ensures subnet is within the created VPC
    cidr_block        = "10.0.1.0/24"     # Specify a valid CIDR block within the VPC's range
    availability_zone = "us-east-1a"      # Adjust to your desired AZ

    tags = {
      Name = "MySubnet"
    }
  }

  resource "aws_instance" "web_server" {
    ami           = "ami-0e1bed4f06a3b463d"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.my_subnet.id

    tags = {
      Name = "WebServer-${local.instance_suffix}"
    }
  }


  # To showcase data block
  data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners      = ["amazon"]
  }

  output "ami_id" {
    value = data.aws_ami.latest_amazon_linux.id
  }

  ```
  ```bash
  $terraform init
  $terraform validate
  $terraform plan
  $terraform apply -auto-approve
  ## Please check AWS console to resources are created
  ```
  ## Graphs
  - It is a powerfull tool for visualizing the relationship and dependencies between the resources
  - `$terraform graph`
  - `-type=` Type of graph (plan, applym, plan-refresh-only, plan-destroy)
  - `-draw-cycles`
  - `-plan=<path to plan file>`
  - Generate output in DOT language

  ```bash
  $cd dynamic_block
  $terraform graph > graph.dot
  $cat graph.dot
  # Use online graphviz tools to visualize the graph using the cat graph.dot output
  ```

  ## Terraform Resource Lifecycles
  - It supports parallel resource management through its resource graph, which optimizes the deployment speeds
  - Lifecycle Arguments
    - `prevent_destroy` - prevents accidental deletion of the resources
    - `create_before_destroy` - ensures that new resources are created before old one created
    - `ignore_changes` - ignore resource from updates





