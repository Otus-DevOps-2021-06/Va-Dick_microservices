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



---
# Docker-4
Done:
- Working with networks in Docker;
- Using docker-compose;
- Complete tasks with *;


## Main task
By default, project name = directory name. You can change it by running the docker-compose command with the flag:
```
-p, --project-name NAME
```

## Additional tasks:
- Change the code of each of the applications withoutbuilding the image;
```
# The example is located in file "src/docker-compose.override.yml"
    volumes:
     - ./${service_name}/:/app/:ro
```

- Run puma for ruby applications in debug mode with two workers (flags --debug and-w 2).
```
# The example is located in file "src/docker-compose.override.yml"
    command: bash -c "cd /app && puma --debug -w 2"
```



---
# Gitlab-ci-1
Done:
- Prepare the Gitlab CI installation;
- Prepare a repository with the application code;
- Describe the pipeline stages for the application;
- Define environments;
- Complete tasks with *;

## Additional tasks:
- Automating the deployment of GitLab and worker
```
# Ansible playbook is located in the folder:
docker-monolith/infra/ansible/playbooks
# The ansible role is located in the folder:
docker-monolith/infra/ansible/roles
```

- Launching reddit in a container
```
# Pipeline is located in:
.gitlab-ci
```

- Configuring notifications in Slack:
https://devops-team-otus.slack.com/archives/C026PK2SNR2



---
# Monitoring-1
Done:
- Prometheus: launch, configuration, introduction to the Web UI
- Monitoring the status of microservices
- Collecting host metrics using an exporter
- Complete tasks with *;

## Additional tasks:
- Add MongoDB monitoring to Prometheus using the required exporter;
- Add the monitoring of comment, post, ui services to Prometheus using the blackbox exporter;
- Creating a makefile
