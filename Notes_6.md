# Configuration Management with Ansible and Terraform 26 January 2025

## Jinja2 Template (Countinue...)

- Array
`{% set arrayName = [value1, value2, value3] %}``{{ arrayName[0] }}`
- Conditional statement
- Loop `{% for item in array_name %} {{ item }} {% endfor %}`
- Array filters `{{ array_name | filter_name }}`

### Ansible Facts
- Host specific data and properties to which users connect
- It uses the setup module to gather facts every time before running the playbooks.
- `ansible all -m setup`
- `ansible all -m setup -a "filter=ansible_cmdline"`
- The ansible playbook will have the variable `ansible_facts` contain the host information if gather_facts enabled

### Variable File in Jinja2 
- Used to store and manage variables separatley fomr the main templates.
- Separation of concerns - store variable separately to allow templates to focus on layout and design
- Simplication of updates - reuse variables accross multiple templates and centralized changes.

### Variable File: Path
- `-var-file` option provides the path to the file containing variables.
- File path rule
    - Absolute Path
    - Relative to the project path
    - Relative to the Ansible folder

### Control Structure
- Used to manage the flow of template rendering and enable dynamic content insertion through loops and conditional statements.

### Jinja2 examples

- Create variable file
```YAML
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

- Create python script for rendering
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
- Execute python  `python3 python/jinja_renderer.py`

