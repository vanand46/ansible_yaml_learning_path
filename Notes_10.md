# Configuration Management with Ansible and Terraform – 09 February 2025  
## Terraform State
- It is a file that tracks the state of infrastructure managed by Terraform.
- It contains the details of all resources along with status such as ACTIVE, DELETED and PROVISIONING

### Purpose of using the Terraform State
- Act as database to map configurations to real-world resources.
- Ensures that each resource in the configuration corresponds to a specific remote object.
- Tracking and management of infrastructure changes.
- Tracks dependencies between resources.
- Planning and application speeding by caching the attribute values of all resources.
- Reduces the need for querying all resources.

### Core components of Terraform State Files
- version - Version of the state file format
- terraform_version - Indicates the version of terraform
- serial - auto_increment with every state change
- outputs - stores output values defined in the Configuration
- lineage - Unique identifier for state file lineage
- resources - List of all managed resources
  - type - type of the resource
  - name - name of the resource
  - provider - identifies the provider used for managing the resource
### Instances in State File
- It provides the current state attributes and dependencies for each resource ensuring accurate state management.
- Each resource can have multiple instances
  - attributes
  - dependencies
## Terraform Backends
- It defines where and how Terraform stores state data.
- Configuring a backend to store the state file for user infrastructure is crucial
- Without a backend , the user will have to manually manage the state file.
- Two types of back end
  - Local Backend - stores state file on the local disk.suitable for individual project
  - Remote Backend - stores the state file in a remote , shared store.
 