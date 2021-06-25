# Va-Dick_microservices
Va-Dick microservices repository


---
# Docker-2
Done:
- Creating a docker host
- Creating your own image
- Working with Docker Hub
- Complete tasks with *

##Additional tasks:

Ansible
```
# Installing additional roles
cd /dockermonolith/infra/ansible && ansible-galaxy install geerlingguy.pip && geerlingguy.docker
```

Vagrant:
```
# Start the VM:
cd /dockermonolith/infra/ansible && vagrant up

# Delete a VM:
cd /dockermonolith/infra/ansible && vagrant destroy -f
```

Paker:
```
# You need to change the variables.json file, the example is in the variables.json.example file
cd /dockermonolith/infra && packer build -var-file=packer/variables.json packer/reddit_in_docker.json
```

Terraform:
```
# # You need to change the terraform.tovars file, the example is in the terraform.tfvars.example file
cd /home/vmartinov/Otus/Microservices/Va-Dick_microservices/dockermonolith/infra/terraform/stage && terraform apply -auto-approve
```
