# Configuration Management with Ansible and Terraform 19 January 2025

## Global Variables in Ansible
``` INI
[mygroup]
host1
host2

[mygroup]
host1 my_var="123"
host2 my_var="123"
```
``` INI
[mygroup:vars]
my_var="123"

[mygroup]
host1
host2
```
- host_vars -> directory used to store host specific variable fies
- host1.yaml -> variable for host 1
- host2.yaml -> variable for host 2
- group_vars ->
```script
#mkdir ansible_demo
#cd ansible_demo/
#mkdir group_vars
#nano group_vars/all.yml
```
```YAML
---
greeting: "Hello World!!"
custom_number: 47
...
```

- Write a playbook file
```script
$nano demo_playbook.yaml
```
``` YAML
- name: Demo playbook for group vars testing
  hosts: all
  gather_facts: no

  tasks:
	- name: Print the greeting message
  	debug:
    	msg: "My Greetings: {{ greeting }}"

	- name: Print the custom number
  	debug:
    	msg: "My Number: {{ custom_number }}"
```        
``` script
$ansible-playbook demo_playbook.yaml --syntax-check
```


## Working with YAML file Operations
- Loading YAML data (py-yaml, js-yaml, snakeyaml)
- Saving YAML data
- Validation and error handling
  - Consistency
  - Accuracy
  - Security
  - Logging
  - User feedback
- Best Practices for writing YAML file
  - Consistent Indentation
  - Give the keys descriptive and meaningful name
  - Keep nesting level to a minimum
  - YAML is case sensitive
  - Use comments
  - Seperate section with blank lines

## YAML in different contexts
- YAML as configuration files
- YAML for data serialization

## Using YAML data serialization in Python
``` script
#nano seriliaze.py
```
```py
import yaml

# Create python dictionary
data = {
	'title': 'YAML Serialization Example',
	'version': '1.0',
	'items': ['item1', 'item2', 'item3']
}

# Serialize the dictionary to YAML file
with open('serial_output.yaml', 'w') as file:
	yaml.dump(data, file)

print('Data Serialization complete')
```
``` script
#python seriliaze.py
#cat serial_output.yaml
```
## Writing Ansible Playbooks
### Playbooks
 - YAML Script that defines tasks for remote hosts
 - Purspose
    - Automation
    - Configuration Management
    - IaC
#### Playbook syntax
 - '---' Start of the YAML
 - name - name of the playbook
 - host - target machines
 - become - esclate privileges
 - variables - custom variables
 - task - tasks to perform
 - handlers
 - roles
 - modules
 
### Install Node JS using playbook
``` script
#nano node.yaml
```
```YAML
 ---
- name: Install nodejs
  hosts: all
  gather_facts: yes
  become: true

  tasks:
	- name: Add apt key for node installation source
  	apt_key: url=https://deb.nodesource.com/gpgkey/nodesource.gpg.key

	- name: Add the node repo
  	apt_repository:
    	repo: 'deb https://deb.nodesource.com/node_0.10 {{ ansible_distribution_release }} main'
    	update_cache: no

	- name: install nodejs
  	apt: name=nodejs

	- name: verify nodejs
  	shell: node --version
```    
``` script
$ansible-playbook node.yaml -K	 
$ansible all -m shell -a "node --version"
$ansible-playbook node.yaml -K --verbose
```

### Playbook execution in Ansible
- Sequential execution
- Multiple plays
- Host Management
- Task execution
- Desired State
- Idempotency
- Running a playbook
   - ansible-playbook node.yaml -f 10 // number of forks
   - --verbose mode to see logs
   - --check // to dry run
   - --syntax-check // to check syntax of the playbook
- Using variables in Playbook
  - Variable names should be meaningful and descriptive
  - Only inclue letters, numbers and under_score
  - can not start witn number and special characters
  - python/playbook keywords not allowed
- Types of Variables
  - simple variables
  - referencing variable ({{}})
  - list variables
  - dictionary variables
- Defining variable in inventory  
- Defining variable in inventory  
```YAML
---
- hosts: all
  vars:
    salutations: Hello everyone!

  tasks:
    - name: Using Ansible variable
      debug:
        msg: "Sal: {{ salutations }}"
    
    - name: Print the greeting message
      debug:
        msg: "My Greetings: {{ greeting }}"

    - name: Print the custom number
      debug:
        msg: "My Number: {{ custom_number }}"

    - name: Nested Loop
      debug:
        msg: "Item 1 : {{ item.0}} - {{ item.1 }}"
      with_nested:
        - ['A', 'B', 'C']   
        - ['1']
...
```        
### Task Iterations with Loops
- Ansible loops
  - Loop,
  - with_<lookup>
  - until
  - Standard Loop
	- with_items keyword
	- loop
  - Nested Loop
	- with_nested
  - Looping over range
	- with_sequence: start=0 end=4
  	stride=2 format=
  - Dictionary loop
 	- with_dict





