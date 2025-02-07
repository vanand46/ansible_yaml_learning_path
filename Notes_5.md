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

## Ansible Handlers
- Special tasks that should be notified by other tasks
- Single handler can be notified by multiple tasks
  - the handler task will be executed only once as part of the play execution
  - the handler tasks execution will happen only after all other task execution are complete
- Sinlge task can notify multiple handlers  

### Controlling When Handlers Run
- By default, Ansible handlers run after all tasks in a play are completed.
- To run handlers before the end of the play, use `meta: flush_handlers`

### Handlers Example
- Multihandler example
```YAML
---
- hosts: localhost
  gather_facts: no

  tasks:
    - name: "Task 1"
      command: hostname
      notify: 
        - Handler1
        - Handler2

    - name: "Task 2"
      command:  hostname
      notify: 
        - Handler1
    
    - name: "Task 3"
      command: hostname
  
  handlers:
    - name: Handler1
      debug:
        msg: "Running Handler 1..."

    - name: Handler2
      debug:
        msg: "Running Handler 2..."

    - name: Handler3
      debug:
        msg: "Running Handler 3..."        
...
```

- Flush handler example

```YAML
---
- hosts: localhost
  gather_facts: no

  tasks:
    - name: "Task 1"
      command: hostname
      notify: 
        - Handler2

    - name: "Task 2"
      command:  hostname
      notify: 
        - Handler1

    - name: "Flush all handlers till Task 2"
      meta: flush_handlers
    
    - name: "Task 3"
      command: hostname
      notify:
        - Handler3
        - Handler1
  
  handlers:
    - name: Handler1
      debug:
        msg: "Running Handler 1..."

    - name: Handler2
      debug:
        msg: "Running Handler 2..."

    - name: Handler3
      debug:
        msg: "Running Handler 3..."    
...
```

## Ansible Filters
- Same as python filters
- Using Jinja 2 templates
- Used to tranform/manipulate data
- Used to perform mathematical operations

### Commonly used filters
- String filters
    - lower
    - upper
    - replace
- Number filters 
    - round
    - abs
    - int
- Date and time filters
    - strftime
    - timestamp
- List and dictionary filters
    - sort
    - unique
    - join 
### Filters for Data Structures
``` Jinja
{{ some_variable | to_json }}
{{ some_variable | to_yaml }}
{{ some_variable | to_nice_json }}
{{ some_variable | to_nice_yaml }}
{{ some_variable | from_json }}
{{ some_variable | from_yaml }}
```
### Filters for List
``` Jinja
{{ list1 | min }}
{{ [6, 5, 1] | max }}
{{ [6, 5, 1, [09, 56]] | flatten }}
```

### Filters for Dictionary
``` Jinja
{{ dict | dict2items }}
{{ tags | items2dict }}
```

- Filters Example

```YAML
---
- name: Ansible Filters
  hosts: localhost
  gather_facts: no

  vars:
    sample_list: [100, 200, 300, 400, 500]
    sample_list_alt: [100, [200, 300], 400, 500]
    sample_string: "this is test message"
    sample_dict:
      a: "ab"
      b: "bc"
  
  tasks:
    - name: List to comma-separated string
      debug:
        msg: "{{ sample_list | join(',') }}"
    
    - name: Flatten list
      debug:
        msg: "{{ sample_list_alt | flatten }}"
    
    - name: Capitalize String
      debug:
        msg: "{{ sample_string | capitalize }}"

    - name: Convert dict to items
      debug:
        msg: "{{ sample_dict | dict2items }}"    
    
    - name: Convert dict to list of keys
      debug:
        msg: "{{ sample_dict | dict2items | map(attribute='key') | list }}"

    - name: Sum 
      debug:
        msg: "{{ sample_list | sum }}" 
    
    - name: Sort 
      debug:
        msg: "{{ sample_list | sort(reverse=True) }}" 
...
```

