# Configuration Management with Ansible and Terraform

### Conditionals Example
```yaml
- hosts: localhost
  become: true
  tasks:
    - name: Execute only if os_family is Debian
      debug:
        msg: "This is a Debian machine"
      when: ansible_os_family == "Debian"
    
    - name: Execute only if os_family is Ubuntu
      debug:
        msg: "This is an Ubuntu machine"
      when: ansible_os_family == "Ubuntu"

    - name: Execute only if os_family is Debian alternative
      debug:
        msg: "This is a Debian machine verified using Ansible facts"
      when: ansible_facts['os_family'] == "Debian"

    - name: Test whether the machine is running Ubuntu and version is 20
      debug:
        msg: "This is a machine running Ubuntu 20"
      when: ansible_facts['distribution'] == "Ubuntu" and ansible_facts['distribution_major_version'] == "20"

    - name: Test whether the machine is running Ubuntu and version is 22
      debug:
        msg: "This is a machine running Ubuntu 22"
      when:
        - ansible_facts['distribution'] == "Ubuntu"
        - ansible_facts['distribution_major_version'] == "22"

    - name: Test whether the machine is running Ubuntu 14 and above
      debug:
        msg: "This is a machine running Ubuntu 14 and above"
      when:
        - ansible_facts['distribution'] == "Ubuntu"
        - ansible_facts['distribution_major_version'] | int >= 14

    - name: Test whether the machine is running Ubuntu or CentOS
      debug:
        msg: "This is a machine running Ubuntu or CentOS"
      when: ansible_facts['distribution'] == "CentOS" or ansible_facts['distribution'] == "Ubuntu"             
```

### Register Keyword
Used for creating variables during runtime.

- Example
```yaml
---
- hosts: localhost
  gather_facts: no
  tasks:
    - name: Check if the file exists in the path
      stat:
        path: ~/demo.txt
      register: file_status
      
    - name: Print the execution output
      debug:
        msg: "{{ file_status }}"

    - name: Create the file if it does not exist
      file:
        path: ~/demo.txt
        state: touch
      when: not file_status.stat.exists

    - name: Execute if the first task is successful
      debug:
        msg: "New task execution if the first task execution is done"
      when: not file_status.failed

    - name: Execute if the first task fails
      debug:
        msg: "New task execution if the first task execution failed"
      when: file_status.failed
...
```

## Ansible Handlers
- Special tasks that should be notified by other tasks.
- A single handler can be notified by multiple tasks.
  - The handler task will be executed only once as part of the play execution.
  - The handler task execution will happen only after all other task executions are complete.
- A single task can notify multiple handlers.  

### Controlling When Handlers Run
- By default, Ansible handlers run after all tasks in a play are completed.
- To run handlers before the end of the play, use `meta: flush_handlers`.

### Handlers Example
- Multi-handler example
```yaml
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
      command: hostname
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

### Flush Handler Example
```yaml
---
- hosts: localhost
  gather_facts: no

  tasks:
    - name: "Task 1"
      command: hostname
      notify:
        - Handler2

    - name: "Task 2"
      command: hostname
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
- Same as Python filters.
- Uses Jinja2 templates.
- Used to transform/manipulate data.
- Used to perform mathematical operations.

### Commonly Used Filters
- **String filters**
    - lower
    - upper
    - replace
- **Number filters**
    - round
    - abs
    - int
- **Date and time filters**
    - strftime
    - timestamp
- **List and dictionary filters**
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

### Filters for Lists
``` Jinja
{{ list1 | min }}
{{ [6, 5, 1] | max }}
{{ [6, 5, 1, [9, 56]] | flatten }}
```

### Filters for Dictionaries
``` Jinja
{{ dict | dict2items }}
{{ tags | items2dict }}
```

## Jinja2 Template

- Python templating engine.
- Dynamic content creation (embedded expressions).
- Used in Flask and Django.
- Template + Context data = Jinja2.
- `.j2` is the file extension.
- Context Data - values for the variables in a template.
- Output - rendered output (expressions replaced with values).

### Jinja2 Delimiters
- `{{ }}` - To embed variables.
- `{% %}` - For control statements (used for dynamic rendering logic; not part of final output).
- `{# #}` - Used for comments in Jinja templates (not included in final output).
- `#` - Single-line execution.
- `##` - Inline comment.

### Example Jinja2 Rendering in Python
```py
from jinja2 import Template

template = Template("Hello, {{ name }}")
rendered = template.render(name="Alice")

print(rendered)
```

### Filters Example
``` Jinja
{{ "apple" | upper }}
{{ "apple" | upper | capitalize }}
{{ user.age | default(25) }}
{{ user.age | format() }}
```

