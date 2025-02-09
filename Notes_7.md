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
## Ansible Vault     
- Feature of Ansible that provides encryption for sensitive data
- It integrates with services like Amazon AWS KMS.
- Operations in Vault
    - Encrypt a file 
    - Create an encrypted file
    - Decrypt a file
    - View an encrypted file without decrypting
    - Edit an encrypted file
    - Reset the encryption key
- Levels of encryption
    - File level encryption
    - Variable level encryption (key: !vault)
- Steps to encrypt or decrypt content with Ansible Vault
    - Access passwords stored in third-party tool using a script
    - Encrypt or decrypt content using the ansible-vault command-line tool with passwords
    - Store encrypted content in source control and share it securely

### Examples Ansible Vault

- Create a new encrypted file
```sh
$ansible-vault create vault1.yml
### console stream or output
New Vault password: 
Confirm New Vault password:
## Provide the file data
$cat vault1.yml
### console stream or output
$ANSIBLE_VAULT;1.1;AES256
38623139643061353564326139333063366566376231663030386461383633363666656161306632
6330623839663934353830343132383738663232323737660a313434366236326462333532366536
32666633346366353036643764316264333064316564653566613531303237323733633931306362
6431363438633239350a373637386234356436383663323933623730383436356533336534363863
33313263386231616632323430313234613434353666383766386364613038343365
```
- View the created encrypted file
```bash
$ansible-vault view vault1.yml ## will ask for password
### console stream or output
Vault password: 
it is the secert datat
```
- Edit the encrypted file 
```bash
$ansible-vault edit vault1.yml #will ask for password
### console stream or output
Vault password:
## Edit and save the file
$ansible-vault view vault1.yml #will ask for password
### console stream or output
Vault password: 
it is the secert data.Edited
```
- Change the password of the encrypted file
```bash
$ansible-vault rekey vault1.yml
### console stream or output
Vault password: ## current password
New Vault password: 
Confirm New Vault password: 
Rekey successful
```
- Decrypt the file
```bash
$ansible-vault decrypt vault1.yml
### console stream or output
Vault password: 
Decryption successful
$cat vault1.yml
### console stream or output
it is the secert data.Edited
```

- Encrypt the file
```bash
$ansible-vault encrypt vault1.yml
### console stream or output
Vault password: 
Encryption successful
$ cat vault1.yml
### console stream or output
$ANSIBLE_VAULT;1.1;AES256
62656634633435613661643537623339643931633437353833356139313134633031613863643335
3939613934383562353862616466363962623064633961380a393830373530336332333466636630
34633839396332663664306661656261356535613233656136656466646537346138336437333930
3737316534306666380a643933666531316631363037333934653931653362633931363138393537
32316336356136366564653035353266396132353961616137616166346339666634
```

- Password from the file
```sh
$echo "123" >> pass_file
```

- Use the password file
```sh
$ansible-vault view vault1.yml --vault-password-file pass_file
### console stream or output 
it is the secert data.Edited
```

- Encrypt with vault id
```sh
$echo  "vault test" > vault_test.txt
$ansible-vault encrypt --vault-id myid@pass_file vault_test.txt
###  console strem or output
Encryption successful
$cat vault_test.txt
###  console strem or output
$ANSIBLE_VAULT;1.2;AES256;myid
34626632353737316631656166306363356430353464663631666139316336336136633234333165
3261336439623037633436356565316534653437636563630a356530636333613139363964653935
39653831353231353362326333313337613539663839343262313139353838346530646332663436
6232306335303534300a333836376235363166346631383739613536656539316537366465303364
6565 
$ansible-vault encrypt --vault-id myid@prompt vault_test.txt ## for prompting password instead of password file
```

- Use encrypted file in adhoc command
```sh
$ ansible localhost -m copy -a "src=vault_test.txt dest=~/from_vault_test.txt"
###  console strem or output
localhost | FAILED! => {
    "msg": "A vault password or secret must be specified to decrypt /workspaces/ansible_yaml_learning_path/vault_test.txt"
}
$ ansible localhost -m copy -a "src=vault_test.txt dest=~/from_vault_test.txt" --ask-vault-pass
### console strem or output
Vault password: 
[WARNING]: A duplicate localhost-like entry was found (127.0.0.1). First found localhost was localhost
localhost | CHANGED => {
$ cat ~/from_vault_test.txt
$ ansible localhost -m copy -a "src=vault_test.txt dest=~/from_vault_test1.txt" --vault-password-file pass_file
$ cat ~/from_vault_test1.txt
```

## Error Handling and Troubleshooting in Ansible
- Using Blocks (block, rescue and always)
- ansible_failed_task
- ansible_failed_result
- --syantax-check
- --flush-cache




