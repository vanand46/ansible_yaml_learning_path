# Configuration Management with Ansible and Terraform

## Jinja2 Template (Continue...)

- Array
  ```
  {% set arrayName = [value1, value2, value3] %}
  {{ arrayName[0] }}
  ```
- Conditional statement
- Loop `{% for item in array_name %} {{ item }} {% endfor %}`
- Array filters `{{ array_name | filter_name }}`

### Ansible Facts
- Host-specific data and properties to which users connect
- It uses the setup module to gather facts every time before running the playbooks.
- `ansible all -m setup`
- `ansible all -m setup -a "filter=ansible_cmdline"`
- The Ansible playbook will have the variable `ansible_facts` containing the host information if `gather_facts` is enabled.

### Variable File in Jinja2
- Used to store and manage variables separately from the main templates.
- Separation of concerns - store variables separately to allow templates to focus on layout and design.
- Simplification of updates - reuse variables across multiple templates and centralized changes.

### Variable File: Path
- `-var-file` option provides the path to the file containing variables.
- File path rules:
    - Absolute Path
    - Relative to the project path
    - Relative to the Ansible folder

### Control Structure
- Used to manage the flow of template rendering and enable dynamic content insertion through loops and conditional statements.

### Jinja2 Examples

#### Example with Python
- Create variable file
```yaml
---
products:
  - name: Laptop
    price: 1000
    in_stock: true
  - name: Smartphone
    price: 500
    in_stock: false  
  - name: Tablet
    price: 300
    in_stock: false  
discount: 10    
...
```

- Create template file
```j2
Product List:
{% for product in products %}
  - {{ product.name }} for {{ product.price }}
    {% if product.in_stock %}
      Buy now at {{ discount }}% OFF!
    {% else %}
      OUT OF STOCK
    {% endif %}
{% endfor %}     
```

- Create Python script for rendering
```py
import yaml
from jinja2 import Environment, FileSystemLoader

with open('yaml/jinja_data.yaml', 'r') as file:
    data = yaml.safe_load(file)

file_loader = FileSystemLoader('jinja/')
env = Environment(loader=file_loader)

template = env.get_template('jinja_template.j2')

print(template.render(data))
```
- Execute Python script: `python3 python/jinja_renderer.py`

#### Example with Ansible Playbook
- Create Template
```j2
Product List:
{% for product in products %}
  - {{ product.name }} for {{ product.price }}
    {% if product.in_stock %}
      Buy now at {{ discount }}% OFF!
    {% else %}
      OUT OF STOCK
    {% endif %}
{% endfor %}

On the machine {{ ansible_host | default("Custom Machine") }}
```

- Create a playbook
```yaml
---
- hosts: localhost
  vars_files:
    - jinja_data.yaml
  tasks:
    - name: Render file from template
      template:
        src: ../jinja/jinja_template.j2
        dest: ~/rendered_playbook_output.txt
...
```

### Tests in Jinja2
- Variable Testing
- Comparing Versions
- When using versions, do not use `{{ }}`

## Working with Ansible Roles and Vault

### Ansible Roles
- It is a self-contained and portable unit of automation that groups related tasks and associated variables, files, and other assets in a known file structure.
- It can create bundles of automation content that you can run in one or more plays, reuse across playbooks, and share with other users in collections.
- Must be used in a playbook.
- Uses YAML files.
- Set of tasks.
- Enhances code reusability.
- Easily modified.

### Why Ansible Roles?
- Reusability
- Modularity
- Organization
- Parameterization
- Dependency Management
- Versioning
- Simplicity

### Roles Use Cases
- Server provisioning and configuration
- Application deployment
- Security and compliance
- Patch management
- Disaster recovery and backup

### Ansible Role Directory
- It is a predefined directory structure that helps organize various components of a role such as tasks, handlers, variables, templates, and files.
- `tasks`
- `handlers`
- `defaults`
- `vars`
- `files`
- `meta`
- `templates`

### Creating Ansible Role
- Use the utility `ansible-galaxy`
- `ansible-galaxy init role_name`
- Tasks in an Ansible Role
- Storing and finding a role
- Roles relative to the playbook file
- `roles_path`

### Using Ansible Roles
- At the play level
- At the task level (use `include_role` (dynamic) or `import_role` (static))
- As a dependency to another role

### Using Ansible Roles at Play Level
- Order of execution:
    - `pre_tasks`
    - Handlers notified in `pre_tasks`
    - Process roles
    - Tasks within the play
    - Handlers notified in roles and tasks
    - `post_tasks`
    - Handlers notified in `post_tasks`
- Multiple execution of a role:
    - Ansible executes each role once, even if it is defined multiple times.
    - Roles are executed multiple times only if the parameters defined on the role are different for each definition.
    - Inside the `meta` of the role, add `allow_duplicates: true`

### Creating the Roles
```sh
mkdir roles_test
cd roles_test
ansible-galaxy init apache_role
```

- Edit `roles_test/roles/apache_role/tasks/install.yml`
```yaml
---
- name: Install the apache2 package
  apt:
    name: apache2
    state: present
...
```

- Edit `roles_test/roles/apache_role/tasks/config.yml`
```yaml
---
- name: Copy index file to Apache server directory
  copy:
    src: files/index.html
    dest: /var/www/html/
...
```

- Edit `roles_test/roles/apache_role/tasks/service.yml`
```yaml
---
- name: Start the Apache service
  service:
    name: apache2
    state: started
...
```

- Edit `roles_test/roles/apache_role/tasks/main.yml`
```yaml
---
- import_tasks: install.yml
- import_tasks: config.yml
- import_tasks: service.yml
- import_tasks: print_var.yml
...
```

- Create a playbook to use the role `nano roles_test/setup.yml`
```yaml
- hosts: all
  become: true
  roles:
    - apache_role
```

- Execute the playbook:
```sh
ansible-playbook setup.yml
```

