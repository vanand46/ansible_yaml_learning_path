# Configuration Management with Ansible and Terraform 01 February 2025

## Ansible Galaxy

- It is a community hub for finding, sharing and downloading Ansible Content , including roles and collections.
- Find, share and download the Ansible components
- `ansible-galaxy list`
- `ansible-galaxy init [role]`
- `ansible-galaxy remove [role]`

### Ansible Collections
- Collections are a distribution format for Ansible content that includes roles, modules, plugins and other resources.
- Distributed format
- Galaxy Collection Structure
    - Refers to the organized layout of directories and files.
    - galaxy.yml(root level of the collection) contains all the metadata that Galaxy and other tools need to package, build and publish.
    - Install a collections from Galaxy `ansible-galaxy collection install collection_name`
    - `--upgrade` to update the collections
    - Install collection from Automation Hub
    - Install from GitHub
    - It install latest available version otherwise we can use range identifiers.`collection:=>1.0.0, < 2.0.0`
    - Example 
     ```bash
     $ ansible-galaxy role install khaosx.plex-server
     $ ansible-galaxy list
     $ ansible-galaxy role remove khaosx.plex-server
     $ ansible-galaxy list
     ```
     ### Role Attributes
     - src - source of the role
     - scm - specify scm
     - version - role version
     - name - Download the role to specific name
     - Installing multiple roles `ansible-galaxy install -r requirements.yml`
     - Specify roles as dependency in `meta/main.yml`




