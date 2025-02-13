# Configuration Management with Ansible and Terraform – 01 February 2025  

## Ansible Galaxy  

- It is a community hub for finding, sharing, and downloading Ansible content, including roles and collections.  
- Find, share, and download Ansible components.  
- `ansible-galaxy list`  
- `ansible-galaxy init [role]`  
- `ansible-galaxy remove [role]`  

### Ansible Collections  
- Collections are a distribution format for Ansible content that includes roles, modules, plugins, and other resources.  
- Distributed format.  
- **Galaxy Collection Structure**  
  - Refers to the organized layout of directories and files.  
  - `galaxy.yml` (root level of the collection) contains all the metadata that Galaxy and other tools need to package, build, and publish.  
  - Install a collection from Galaxy: `ansible-galaxy collection install collection_name`  
  - `--upgrade` to update the collection.  
  - Install collection from Automation Hub.  
  - Install from GitHub.  
  - It installs the latest available version; otherwise, we can use range identifiers: `collection: >=1.0.0, < 2.0.0`.  
  - **Example:**  
    ```bash
    $ ansible-galaxy role install khaosx.plex-server
    $ ansible-galaxy list
    $ ansible-galaxy role remove khaosx.plex-server
    $ ansible-galaxy list
    ```  

### Role Attributes  
- `src` - Source of the role.  
- `scm` - Specify SCM.  
- `version` - Role version.  
- `name` - Download the role with a specific name.  
- Installing multiple roles: `ansible-galaxy install -r requirements.yml`  
- Specify roles as dependencies in `meta/main.yml`.  

## Ansible Vault  
- A feature of Ansible that provides encryption for sensitive data.  
- It integrates with services like Amazon AWS KMS.  
- **Operations in Vault**  
  - Encrypt a file.  
  - Create an encrypted file.  
  - Decrypt a file.  
  - View an encrypted file without decrypting.  
  - Edit an encrypted file.  
  - Reset the encryption key.  
- **Levels of Encryption**  
  - File-level encryption.  
  - Variable-level encryption (`key: !vault`).  
- **Steps to Encrypt or Decrypt Content with Ansible Vault**  
  - Access passwords stored in a third-party tool using a script.  
  - Encrypt or decrypt content using the `ansible-vault` command-line tool with passwords.  
  - Store encrypted content in source control and share it securely.  

### Examples – Ansible Vault  

- **Create a new encrypted file**  
  ```sh
  $ ansible-vault create vault1.yml
  ```
- **View the created encrypted file**  
  ```bash
  $ ansible-vault view vault1.yml  # Will ask for password
  ```
- **Edit the encrypted file**  
  ```bash
  $ ansible-vault edit vault1.yml  # Will ask for password
  ```
- **Change the password of the encrypted file**  
  ```bash
  $ ansible-vault rekey vault1.yml
  ```
- **Decrypt the file**  
  ```bash
  $ ansible-vault decrypt vault1.yml
  ```
- **Encrypt the file**  
  ```bash
  $ ansible-vault encrypt vault1.yml
  ```
- **Password from the file**  
  ```sh
  $ echo "123" >> pass_file
  ```
- **Use the password file**  
  ```sh
  $ ansible-vault view vault1.yml --vault-password-file pass_file
  ```
- **Encrypt with vault ID**  
  ```sh
  $ ansible-vault encrypt --vault-id myid@pass_file vault_test.txt
  ```
- **Use encrypted file in ad-hoc command**  
  ```sh
  $ ansible localhost -m copy -a "src=vault_test.txt dest=~/from_vault_test.txt" --ask-vault-pass
  ```

## Error Handling and Troubleshooting in Ansible  
- Using Blocks (`block`, `rescue`, and `always`).  
- `ansible_failed_task`  
- `ansible_failed_result`  
- `--syntax-check`  
- `--flush-cache`  

## Working with Dynamic Inventory  
- It is a feature in automation tools like Ansible that automatically retrieves and manages inventory data from various sources in real-time.  
- **Inventory Plugins** – Allow users to connect to various data sources to generate host inventory that Ansible uses to target jobs.  
- **Inventory Scripts**  

### Example of a Script  
- **Python script to get EC2 instances – as a Dynamic Inventory**  
- Install `boto3` and `awscli`:  
  ```bash
  pip install boto3
  pip install awscli
  ```
- **Configure AWS CLI**  
  ```bash
  $ aws configure
  AWS Access Key:
  AWS Secret Key:
  Default Region name:
  Default output format:
  ```
- **Create Python script: `nano python/dynamic_ec2.py`**  
  ```py
  #! /usr/bin/env python

  import boto3
  import json

  def get_ec2_instances():
      ec2 = boto3.resource('ec2')
      instances = ec2.instances.filter(
          Filters=[
              {'Name': 'instance-state-name', 'Values': ['running']}
          ]
      )
      inventory = {'all': {'hosts': []}}

      for instance in instances:
          for tag in instance.tags:
              if tag['Key'] == 'Name':
                  inventory['all']['hosts'].append(instance.public_dns_name)
      return inventory

  def get_dummynodes():
      inventory = {'all': {'hosts': []}}
      inventory['all']['hosts'].append('localhost')
      inventory['all']['hosts'].append('host1')
      inventory['all']['hosts'].append('host2')
      return inventory

  if __name__ == "__main__":
      inventory = get_dummynodes()
      print(json.dumps(inventory))
  ```

## Ansible Tower  
- Formerly known as AWX.  
- Enterprise Ansible version available.  
- Currently known as **Red Hat Ansible Automation Platform**.  
- GUI is available.  
- Role-based access control.  
- Inventory management.  
- Job scheduling.  
- Credential management.  
- Workflow automation.  
- Notifications.  
- Integration with other automation tools.  

