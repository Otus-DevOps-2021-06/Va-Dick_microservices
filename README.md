# Va-Dick_microservices
Va-Dick microservices repository


---
# Docker-2
Done:
- Creating a docker host;
- Creating your own image;
- Working with Docker Hub;
- Complete tasks with *;

## Additional tasks:

Ansible
```
# Installing additional roles
cd /dockermonolith/infra/ansible && ansible-galaxy install geerlingguy.pip && ansible-galaxy install geerlingguy.docker
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



---
# Docker-3
Done:
- Splitting an application into several components;
- Launching a micro service application;
- Complete tasks with *;


## Additional tasks:

- Launching containers with other network aliases:

```
#!/bin/bash

# ENV
DB_COMMENTS_HOST="comment_db_1"
DB_POST_HOST="post_db_1"
POST_HOST="post_1"
COMMENT_HOST="comment_1"


docker network create reddit
docker run -d --rm --network=reddit --network-alias=$DB_COMMENTS_HOST --network-alias=$DB_POST_HOST mongo:latest
docker run -d --rm --network=reddit --network-alias=$POST_HOST --env POST_DATABASE_HOST=$DB_POST_HOST --env POST_DATABASE=$POST_HOST <your-dockerhub-login>/post:1.0
docker run -d --rm --network=reddit --network-alias=$COMMENT_HOST --env COMMENT_DATABASE_HOST=$DB_COMMENTS_HOST --env COMMENT_DATABASE=$COMMENT_HOST <your-dockerhub-login>/comment:2.0
docker run -d --rm --network=reddit --env POST_SERVICE_HOST=$POST_HOST --env COMMENT_SERVICE_HOST=$COMMENT_HOST -p 9292:9292 <your-dockerhub-login>/ui:2.0
```

- Building images based on Alpine Linux:
```
cd src/comment && docker build -t <your-dockerhub-login>/comment:2.0 -f "Dockerfile2" .
cd src/ui && docker build -t <your-dockerhub-login>/ui:2.0 -f "Dockerfile2" .
```

