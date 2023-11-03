# Brief 13

## Préparation du travail

Installation d'Ansible
```code
pip install ansible
```
Création du rôle qui va effectuer les tâches et de la structure des fichiers (dans un repository séparé)
```code
ansible-galaxy role init ANSSI-RECOM
```

## main.yaml
Créer fichier de task dans tasks/main.yaml
```code
---
#tasks file for ANSSI-RECOM
- include: all.yaml
```
Ce fichier lance les tasks dans le fichier all.yaml (cf tasks/main.yml dans https://github.com/RedHatOfficial/ansible-role-rhel8-anssi_bp28_minimal)

## inventory.yaml

```code=
all:
  hosts:
    vm:
      ansible_host: addressIP
```
Déclare une adresse IP en tant qu'hôte (vm)

## playbook.yml

Hôte: vm
User : moi

Installation de l'outil SCAP pour scanner la machine Linux

```code=
---
- name: Install scap-workbench
  hosts: vm
  become: true  # To run tasks with sudo
  remote_user: celia
  tasks:
    - name: Install scap-workbench
      yum:
        name:  
          - scap-workbench
        state: present
```

Lance le rôle et ses tâches
```code
- name: Durcissement système minimal
  hosts: vm
  become: true  # pour exécuter en tant que superutilisateur
  gather_facts: true
  roles:
    - role: "ANSSI-RECOM"
```

Démarre évaluation SCAP pour vérifier que les differentes mesures de durcissement soient bien en place et produit un rapport
```code
- name: Run evaluation
  hosts: vm
  become: true  # To run tasks with sudo
  remote_user: celia
  tasks:
    - name: Run OSCAP evaluation
      ansible.builtin.command:
        cmd: oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_anssi_bp28_minimal --results scap_results.xml --report scap_report.html /usr/share/xml/scap/ssg/content/ssg-rhel8-ds.xml
      ignore_errors: true
```

Copie le rapport de la VM à l'ordi local
```code
- name: Copy result file from VM to local machine
  hosts: vm
  remote_user: celia
  tasks:
    - name: Copy result file using SCP
      ansible.builtin.fetch:
        src: /home/celia/scap_report.html
        dest: /mnt/c/Users/utilisateur/Documents/Brief13/scap_report.html
        flat: yes
      ignore_errors: true
```

## requirements.txt

Référencer le rôle Ansible depuis le dépôt GitHub 
```code
ANSSI-RECOM git+https://github.com/Simplon-CeliaOuedraogo/Brief13-role
```
Installer le rôle et ses dépendances depuis le dépôt GitHub spécifié
```code
ansible-galaxy install -r requirements.txt
```

## azure_rm.yaml

Installer le plugin nécessaire:
```code
ansible-galaxy collection install azure.azcollection
```
Remplace l'inventory pour ne plus avoir besoin de remplacer l'adresse IP à chaque changement de la VM. On peut remplace host par all ou le nom de la VM si il y en a plusieurs
```code
plugin: azure_rm
auth_source: cli
include_vm_resource_groups:
- 'Brief13-Celia' #nom du ressource groupe
```

## VM

Déploiement d'une VM Redhat à l'aide du script du Brief 12

local-exec: exécuter la commande pour appliquer les tasks
```code=
provisioner "local-exec" {
  command = "ansible-playbook playbook.yaml -i azure_rm.yaml"
  working_dir = "/mnt/c/Users/utilisateur/Documents/Brief13/"
}
```

## Note

azure_rm n'a pas fonctionné dans ce brief, donc exécution des tasks avec : 
```code
ansible-playbook -i inventory.yaml playbook.yaml
```
