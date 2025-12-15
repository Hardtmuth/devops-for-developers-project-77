encrypt-token:
	ansible-vault encrypt ./terraform/token.auto.tfvars
decrypt-token:
	ansible-vault decrypt ./terraform/token.auto.tfvars
encrypt-secrets:
	ansible-vault encrypt ./terraform/secret.backend.tfvars
decrypt-secrets:
	ansible-vault decrypt ./terraform/secret.backend.tfvars
encrypt-vmdata:
	ansible-vault encrypt ./terraform/vms.user.auto.tfvars
decrypt-vmdata:
	ansible-vault decrypt ./terraform/vms.user.auto.tfvars

TERRAFORM_DIR = ./terraform

tf-validate:
	cd "$(TERRAFORM_DIR)" && \
	terraform validate
tf-plan:
	cd "$(TERRAFORM_DIR)" && \
	terraform plan
tf-apply:
	cd "$(TERRAFORM_DIR)" && \
	terraform apply


ANSIBLE_DIR = ./ansible

ansible-ping:
	cd "$(ANSIBLE_DIR)" && \
	ansible webservers -i inventory.ini -m ping
ansible-playbook:
	cd "$(ANSIBLE_DIR)" && \
	ansible-playbook playbook.yml -i inventory.ini
ansible-check:
	cd "$(ANSIBLE_DIR)" && \
	ansible-playbook --check playbook.yml -i inventory.ini
