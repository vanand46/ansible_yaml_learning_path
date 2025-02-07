# Configuration Management with Ansible and Terraform 25 January 2025

### Conditionals Example
```yaml
- hosts: localhost
  become: true
  tasks:
    - name: Execute only if os_family is Debian
      debug:
        msg: "This is debian machine"
      when: ansible_os_family == "Debian"
    
    - name: Execute only if os_family is Ubuntu
      debug:
        msg: "This is ubuntu machine"
      when: ansible_os_family == "Ubuntu" 

    - name: Execute only if os_family is Debian alternative
      debug:
        msg: "This is debian machine verified using ansible facts"
      when: ansible_facts['os_family'] == "Debian" 

    - name: Test whether the machie is running Ubuntu and version is 20
      debug:
        msg: "This is  machine running Ubuntu 20"
      when: ansible_facts['distribution'] == "Ubuntu" and ansible_facts['distribution_major_version'] == "20"

    - name: Test whether the machie is running Ubuntu and version is 22
      debug:
        msg: "This is  machine running Ubuntu 22"
      when: 
        - ansible_facts['distribution'] == "Ubuntu"
        - ansible_facts['distribution_major_version'] == "22" 

    - name: Test whether the machie is running Ubuntu 14 and above
      debug:
        msg: "This is  machine running Ubuntu 14 and above"
      when: 
        - ansible_facts['distribution'] == "Ubuntu" 
        - ansible_facts['distribution_major_version'] | int >= 14

    - name: Test whether the machie is running Ubuntu or CentOS 
      debug:
        msg: "This is  machine running Ubuntu or Cent OS"
      when: ansible_facts['distribution'] == "CentOS" or ansible_facts['distribution'] == "Ubuntu"             
```

### Register Keyword
Used for creating variables during runtime

- Example
```YAML
---
- hosts: localhost
  gather_facts: no
  tasks:
    - name: Check the file exists in path
      stat:
        path: ~/demo.txt
      register: file_status
      
    - name: Print the execution output
      debug: 
        msg: "{{ file_status }}"

    - name: Create the file if does not exists
      file:
        path: ~/demo.txt
        state: touch
      when: not file_status.stat.exists

    - name: Execute if the first task is success
      debug:
        msg: "New task execution if the first task execution is done"
      when: not file_status.failed

    - name: Execute if the first task is failure
      debug:
        msg: "New task execution if the first task execution is failed"
      when: file_status.failed
...
```
