# Configuration Management with Ansible and Terraform

## Inventory File Names

### INI:
- `myinventory`

### YAML:
- `myinventory`
- `myinventory.yml`
- `myinventory.yaml`
- `myinventory.json`

## SSH

```sh
$ ssh username@ip_hostname
```
- Default SSH port - `22`

```sh
$ ssh username@ip_hostname -p <your_custom_ssh_port_number>
```
- Custom SSH port - `42006`

```sh
$ ssh localhost
```
- Use the username as the current logged-in user

```sh
$ ssh labuser@localhost
# exit
```

## Ansible: Passwordless SSH

### Machine A to Machine B
- Machine A (Ansible Control Server) should be able to SSH into Machine B (Ansible Node) without requiring a password.

### Steps for Passwordless SSH:

1. **Create an SSH Keypair**
   ```sh
   [A]$ ssh-keygen
   ```
   - Press `Enter`
   - Overwrite? Press `y` (only if the keypair with the same name already exists)
   - Passphrase: Press `Enter` for an empty passphrase
   - Confirm Passphrase: Press `Enter` for an empty passphrase

2. **Copy the public key from Machine A**
   ```sh
   [A]$ cat ~/.ssh/id_rsa.pub
   ```

3. **Go to Machine B and paste the copied public key**
   ```sh
   [B]$ nano ~/.ssh/authorized_keys
   ```
   - Paste the copied public key from Machine A
   - To save in Nano: `Ctrl X + y + Enter`

4. **Verify the setup**
   ```sh
   $ cat ~/.ssh/authorized_keys
   $ ssh localhost
   # exit
   ```

### Ansible Verification

- [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Check Ansible version:
  ```sh
  $ ansible --version
  ```

## Ansible Inventory File

```sh
$ sudo nano /etc/ansible/hosts
```

```ini
[myservers]
localhost

[myserverips]
YOUR_SERVER_IP
54.89.236.145
```

### Using a Custom Port for SSH
```ini
[myservers]
localhost:22

[myservers]
localhost:42006
```

## Listing Hosts and Inventory
```sh
$ ansible-inventory --list
$ ansible-inventory --graph
$ ansible all --list-hosts
$ ansible myservers --list-hosts
$ ansible myserverips --list-hosts
```

## Running Ansible Modules
```sh
$ ansible -m <module_name> <target>
# OR
$ ansible <target> -m <module_name> 
```

### Ping Module
```sh
$ ansible -m ping localhost
$ ansible -m ping all
```

## Ansible Ad-hoc Commands

### Syntax
```sh
$ ansible <host-pattern/target> -m <module-name> -a "<arguments/params-for-the-module>"
```

### Reboot a Server
```sh
$ ansible all -m reboot
```

### Copy a File from Local to Remote
```sh
$ ansible all -m copy -a "src=/source/path/to/file dest=/destination/path/to/file"
```

### Managing Packages
```sh
$ ansible all -m apt -a "name=tree state=latest"
```

### Managing Services
```sh
$ ansible all -m service -a "name=httpd state=restarted"
```

### Gathering Facts
```sh
$ ansible all -m setup
$ ansible localhost -m setup
$ ansible 12.12.123.12 -m setup
```

## Parallel Execution
```sh
[dbservers]
host1
host2
host3
host4
```

```sh
$ ansible dbservers -m ping
$ ansible dbservers -m ping -f 2
```

## Module Help Documentation
```sh
$ ansible-doc -h
$ ansible-doc <module_name>
$ ansible-doc ping
```

## Shell Command Execution

### Using the Shell Module
```sh
$ ansible all -m shell -a "hostname"
$ ansible all -m shell -a "pwd"
```

### Running Direct Commands
```sh
$ ansible all -a "hostname"
$ ansible all -a "pwd"
```

### File Module Example
```sh
$ ansible localhost -m file -a 'dest=~/sample.txt state=touch mode=600 owner=labuser group=labuser'
$ ls -l
$ cat sample.txt
```

### Copy Module Example
```sh
$ ansible localhost -m copy -a 'content="My DEMO Content" dest=~/my_demo.txt'
$ ls -l
$ cat my_demo.txt
```

### Installing Packages
```sh
$ tree --version
$ ansible localhost -m apt -a "name=tree state=present"
$ ansible localhost -m apt -a "name=tree state=present update_cache=yes" --become
$ ansible localhost -m apt -a "name=tree state=absent" --become
$ ansible localhost -a "tree --version"
```

### Gathering Facts
```sh
$ ansible localhost -m setup
$ ansible localhost -m setup -a "filter=ansible_hostname"
$ ansible localhost -m setup -a "filter=ansible_user_*"
$ ansible localhost -a uptime
$ ansible localhost -a "free -m"
```

## Idempotence
- If you execute the same module multiple times on the same machine, and the desired state is already achieved, then the subsequent executions will not have any effect at all.

### Debug Module
```sh
$ ansible localhost -m debug -a "msg=HelloWorld!"
$ ansible localhost -m debug -a "msg=$PWD"
```

## Template Module
- Uses **Jinja2** Python Templating engine.
- Create a template file: `my_template.j2`
- Use the template file in the template module:

```yaml
template:
  src: /path_to_template_folder/my_template.j2
  dest: /etc/myconfig.conf
```

## Types of Ansible Facts
- **List**: (list of items - generally represented using `[]`)
- **Dictionary**: (collection of key-value pairs represented using `{}`)
- **Ansible Unsafe Text**: (plain text data - like string, number)



















