# Configuration Management with Ansible and Terraform

## Introduction to Configuration Management

- Helps us to configure n number of devices in DevOps ecosystem
- Consistency
- Verification
- To prevent configuration drift
- To ensure that current state = desired state
- Change management
- Traceability
- Enhanced collaboration
- Improved quality control
- Scalability
- Disaster Recovery

<p>It ensures consistent and accurate configurations of systems across complex environments where changes are frequent, collaboration is necessary and compliance with regulations is crucial.</p>

## Configuration Management Scope
- Software and Server Configurations
- Efficiency
- Configuration Items
### Configuration Management Process
- 3 processes
    - Configuration Identification (Desired state is identified)
    - Configuration Regulation (Actual configuration is applied - current state = desired state)
    - Configuration Compliance (Audits and ensure compliances.Identify configuration drift)
### Benefits of Configuration Management
- Improved consistency and reliability
- Improved security and compliance
- Reduced downtime and costs
- Easier Troubleshoots

## Automating Configuration Management

<p>The objective of configuration management is to maintain computers in their desired state.This was traditionally managed manually or through proprietary programming by system administrators.

Automation involves using softwares to perform operations such as configuration management to reduce costs, time, complexity and effort </p>
<b>`Provisioning Tool -> CM Tool -> CI -> CD -> CM`</b>

## Configuration Management Tools
- CM Server or Control Server
- Nodes
### 2 Types of CM tools based on communication b/w nodes and server
#### Pull based (Chef and puppet)
- Agent based
- Constant Poll along with current state of the node
- Server will store about nodes
- Agents 
    - Responsible for initiating the communication
    - Download the configuration information from the server to node
    - Implementation of configuration items on the node
- Agent management is our responsibility
- Control server should be always running
- Set up can be complex
#### Push based (Ansible and SaltStack)
- Agent less 
- From the CM server to the node
- Gather the information about the node
- Server will store the information
- Server 
   - Responsible for initiating the communication
   - Sending the configuration information from the server to node
   - Implementation of configuration items on the node
- CM server need not be running always
- Setup will be simpler
### CM Tools
- Puppet
  - Pull based
  - Written in Ruby DSL
  - Syntax Ruby
  - Manifest 
- Chef
  - Pull based
  - Written in Ruby DSL
  - Syntax Ruby
  - Recipe
- Ansible
  - Push based
  - Python
  - Yaml
  - Playbook
- SaltStack
  - Push based
  - Python
  - Yaml
- Rudder
  - GUI based
### Features of CM tools
- Version control
- Declarative configuration
- Policy enforcement
- Inventory management
- Patch management
- Reporting and auditing
- Application deployment
- Reducing errors

## Infrastructure as Code (IaC)
- Managing and provisioning infrastructure by defining files
- Converting infrastructure to code
  - Automation
  - Consistency
  - Efficiency
  - Scalability
### Roles of IaC
- It manages configuration item
- Multiple environments
- Integrates with version control
- Documents software modification infrastructure configurations.
### Declarative and Imperative Approach in IaC
- Declarative Approach (Terraform)
  - Focus on “what”  - rather than “how”
- Imperative Approach(Jenkins)
  - Focus on “how” - rather than “what”
### Benefits of IaC
- Ensure speed of deployment
- Increase software development efficiency
- Handle risk minimization
- Manage consistency in configuration

## Ansible
- It is python based configuration management tool
- CI files are playbook files
- In YAML syntax
- Agent less - push based
- CM and nodes based on SSH/WinRM
- It has an easy learning curve.
- Launched in 2012 and acquired by RedHat
- It can manage both windows and Linux but nodes CM server will be always linux
- Concept of Playbook
- Inventory
### Why use Ansible?
- Easy to audit 
- Easy to structure
- Compatible with all infrastructures
- Lower system maintenance code
- Leads to faster recovery
### Components of Ansible
- Control Machine 
  - Machine control server
  - Ansible running machine
  - Can be UNIX, it can’t be Windows
- Inventory
  - Host file contains the information about the nodes want to configure
  - Hosts and hosts groups
  - Hosts(/etc/ansible/hosts)
  - Formats: ini/YAML
  - Can manage multiple inventory files
- Playbook
  - Written  in YAML
  - Configuration information
  - Contain one or more plays
  - Play
    - Single configuration information
    - Executing a task
  - Collection of tasks - play
  - Collection of plays - Playbook
- Task
  - Execution of Ansible Module
  - Defining a single process
- Module
  - Scripts written in Python
  - Executed inside the nodes - configuration regulation
  - file/service/infrastructure
  - Desired state -> as input parameter
- Role
  - Collection of playbooks
  - Pre-defined directory structure
  - Primary method to share the configuration
  - Ansible Galaxy - marketplace for Ansible Roles
- Facts
  - Terminology used to Information that is collected by CM server  about the nodes
  - Stored a global variable
  - Can access and use these fact values inside your playbook
- Handlers
  - Type of tasks
  - Execution of ansible modules
  - Needs to be triggered 
  - Specials tasks which should be triggered
  - Executed only once as part of the play execution and only executed at the end
### Ansible Working Architecture
<p>Ansible operates by establishing connections to nodes and deploying small programs, referred to as Ansible modules.By default it runs these modules over SSH and removes them upon completion.

Modules can be stored on any machine, eliminating the need for servers , daemons or databases

The management node acts as the controlling node, overseeing the execution of the playbook.This playbook is YAML code designed to carry  out small tasks on client machines.

The management node establishes an SSH connection and executes modules on the hosts.</p>
### Advantages of Ansible
- Ansible Galaxy 
- Agentless
- Easy and simple to learn
- Playbooks based on YAML
- Written in Python which is easily understable
### Drawbacks of Ansible
- No concept of state
- New to the market
- Little Windows support
- In adequate user interface
- Little commercial support
### Ansible Configuration
#### Managing Inventory File
- Any machine that supposed to be part of ansible, then it should be added to inventory file
- Plain text file which contains the IP/hostname/DNS names of your machines.
- You can group them under hostgroups
- /etc/ansible/hosts default inventory file location
- 2 formats 
  - INI -> default format
  - YAML
```
# Example INI
mail.example.com
[webservers]
foo.example.com
bar.example.com
[Observers]
one.example.com
two.example.com
three.example.com
```
```
# Example YAML
all:
hosts:
mail.example.com:
children:
webservers:
hosts:
foo.example.com:
bar.example.com:
dbservers:
hosts:
one.example.com:
two.example.com:
three.example.com:
```

- Custom host files can be used.[-i option]
- Types of Ansible Inventory
  - Static Inventory
    - Plain Text File that contains a list of managed hosts defined by hostnames or IP addresses under a host group
  - Dynamic  Inventory
    - A script in a high-level language is called a dynamic inventory.It is helpful in a cloud like AWS.
- Host - a single node connected to the Ansible server
- Groups - collection of hosts names a single entity.
- Adding variables to inventory
  - Inventory stores variable values related to a specific host or group.
  - Inventory can contain variable values associated with a specific host or group
  - Users can add managed nodes Inventory 



















