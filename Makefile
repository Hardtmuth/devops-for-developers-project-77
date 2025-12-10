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

tf-validate:
	cd terraform & terraform validate
tf-plan:
	cd terraform & terraform plan
tf-apply:
	cd terraform & terraform apply