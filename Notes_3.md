# Configuration Management with Ansible and Terraform 18 January 2025
# Ansible Custom Facts

## User-defined facts

### Data
- Simple & static
- Structured Data

### Code
- Dynamic & executable
- Scripted output

## Custom Fact Creation

1. **Create a fact file** > `customfacts.fact`

```ini
[localfacts]
pkgname=my_pkg
srvc=my_svc
```

2. **Create a playbook & execute it**
   - Create a directory
   - Copy the custom facts file to the target directory
   - Making use of the custom facts (as part of a different playbook or play)
     - Install the `my_pkg` package
     - Ensure the service `my_svc` is running

3. **Verify custom local facts and the service**
   - `setup` -> output
   - `filter=ansible_local`

## Data Types in Ansible Facts

### List
```json
"network_names": ["net1", "net2"]
```

### Dictionary
```json
"network": {
    "network_names": ["net1", "net2"],
    "network_ips": ["netip1", "netip2"]
}
```

### Ansible Unsafe Text
```json
"network_status": "live"
```

---

# Working with YAML

## Overview
- **Yet Another Markup Language**
- Human-readable, easy-to-read
- Used to create configuration files
- Indentation-based structure
- Data serialization language
  - Converts structured data into a format for storage and sharing
  - Examples: YAML, XML, JSON

## YAML vs XML vs JSON

### YAML
```yaml
key1: value1
key2: value2
key3:
  - value3a
  - value3b
```

### XML
```xml
<key1>value1</key1>
<key2>value2</key2>
<key3>
  <li>value3a</li>
  <li>value3b</li>
</key3>
```

### JSON
```json
{
  "key1": "value1",
  "key2": "value2",
  "key3": ["value3a", "value3b"]
}
```

## YAML Properties
- Case-sensitive
- Uses `.yml` or `.yaml` file extensions
- Does not support tabs (use spaces, best practice: 2 spaces)

## Multiline Strings
- **Block Literal style (`|`)**: Preserves newline characters
- **Block Folded style (`>`)**: Ignores newline characters

## YAML Data Types
- **Scalar**: Single value (string, number, boolean)
- **List**: Ordered sequence (items start with `-`)
- **Maps**: Unordered key-value pairs

### Examples

#### Scalar Mapping
```yaml
key1: value1
key2: value2
```

#### List Mapping
```yaml
fruits:
  - apple
  - banana
  - orange
```

#### Nested Mapping
```yaml
person:
  name: Abhi
  address:
    addr1: My address 1
    addr2: My address 2
```

#### Mixed Mapping
```yaml
person:
  name: Abhi
  address:
    addr1: My address 1
    addr2: My address 2
  language:
    - English
    - Hindi
    - Malayalam
    - Tamil
```

---

# Create, Validate & Parse YAML using Python

## Create `yaml_demo.py`
```python
import yaml

def create_yaml():
    data = {
        'name': 'Abhi',
        'age': '20',
        'city': "Mumbai"
    }
    with open('data.yaml', 'w') as file:
        yaml.dump(data, file)

def validate_yaml():
    try:
        with open('data.yaml', 'r') as file:
            data = yaml.safe_load(file)
        print("Valid YAML file")
        return data
    except yaml.YAMLError as exc:
        print("YAML file error:", exc)
        return None

def parse_yaml(data):
    if data:
        print("Name:", data['name'])
        print("Age:", data['age'])
        print("City/Location:", data['city'])

if __name__ == "__main__":
    create_yaml()
    my_data = validate_yaml()
    parse_yaml(my_data)
```

## Run the script
```sh
$ python yaml_demo.py
```

---

# Configuring Apache Webserver using Ansible

## Check Apache status
```sh
$ ansible myservers -m shell -a "service apache2 status"
```

## Install Apache

Create `apache2.yaml`:
```yaml
---
- hosts: myservers
  become: true
  tasks:
    - name: Install Apache2
      apt: name=apache2 update_cache=yes state=latest

    - name: Enable mod_rewrite
      apache2_module: name=rewrite state=present
      notify:
        - restart apache2

  handlers:
    - name: restart apache2
      service: name=apache2 state=restarted
```

## Uninstall & Reinstall Apache

```yaml
---
- hosts: myservers
  become: true
  tasks:
    - name: Uninstall Apache2
      apt: name=apache2 state=absent

    - name: Install Apache2
      apt: name=apache2 update_cache=yes state=latest

    - name: Enable mod_rewrite
      apache2_module: name=rewrite state=present
      notify:
        - restart apache2

  handlers:
    - name: restart apache2
      service: name=apache2 state=restarted
```

## Execute the playbook
```sh
$ ansible-playbook apache2.yaml
```

## Check Apache status
```sh
$ ansible myservers -m shell -a "service apache2 status"
```

---

# Anchors & Aliases in YAML

### Defining reusable content

```yaml
&my_settings
  adapter: mysql
  host: localhost
```

### Using the anchor

```yaml
dev_env:
  <<: *my_settings
  database: my_db

stage_env:
  <<: *my_settings
  database: my_stage_db
```

### Equivalent expanded version
```yaml
dev_env:
  adapter: mysql
  host: localhost
  database: my_db

stage_env:
  adapter: mysql
  host: localhost
  database: my_stage_db
```

## Example with Users

### `users.yml`
```yaml
---
users:
  - &default_address
    address:
      street: "ABC Main St"
      city: "Some City"
      state: "CA"
      zip: "12345"
  
  - name: "Alice"
    <<: *default_address

  - name: "Bob"
    <<: *default_address

  - name: "Charlie"
    <<: *default_address

  - name: "Me"
    address:
      street: "My Street Addr"
      city: "My City"
      state: "FL"
      zip: "34567"
```

### `print_users.yml`
```yaml
---
- name: Print the users with default address
  hosts: localhost
  gather_facts: no

  vars_files:
    - users.yml

  tasks:
    - name: Print user details
      debug:
        msg: "User: {{ item.name }} lives at {{ item.address.street }} street in {{ item.address.city }}, {{ item.address.state }} and zip code is {{ item.address.zip }}"
      loop: "{{ users }}"
      when: item.name is defined
```

### Execute the playbook
```sh
$ ansible-playbook print_users.yml --syntax-check
$ ansible-playbook print_users.yml













