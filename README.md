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





---
# Monitoring-2
Done:
- Monitoring of Docker containers;
- Visualization of metrics;
- Collection of application performance metrics and business metrics;
- Setting up and checking the alert;
- Complete tasks with *.

## Additional tasks:
- Create a Makefile;

- Collecting metrics from the docker daemon;
```
# To configure the Docker daemon as a Prometheus target, you need to specify the metrics-address
$ cat /etc/docker/daemon.json
{
  "metrics-addr" : "10.128.0.28:9323",
  "experimental" : true
}
# You must also restart the daemon:
sudo systemctl restart docker

# To get metrics, you must also specify the local address in the file:
$ cat ./monitoring/prometheus/prometheus.yml
...
  - job_name: 'docker'
    static_configs:
      - targets:
        - '10.128.0.28:9323'
...

# Rebuild the image:
 ./monitoring/Makefile -i prometheus -p false
```

- Collecting metrics from the Docker daemon using Telegraf:
```
# A configuration file was created to collect metrics
$ cat ./monitoring/telegraf/telegraf.conf
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
  gather_services = false
  source_tag = false
  container_name_include = []
  container_name_exclude = []
  container_state_include = ["created", "restarting", "running", "removing", "paused", "exited", "dead"]
  timeout = "5s"
  perdevice = false
  perdevice_include = ["cpu"]
  total = true
  total_include = ["cpu", "blkio", "network"]
  docker_label_include = []
  docker_label_exclude = []

[[outputs.prometheus_client]]
  listen = ":9273"

# To build an image, use the command:
 ..monitoring/Makefile -i telegraf -p false
```

- Implementation of other alerts:
```
# Example of adding a second alert:
$ cat ./monitoring/prometheus/alerts.yml
    - alert: HttpRequestsErrorStatusCode
      expr: rate(ui_request_count{http_status=~"^[45].*"}[1m]) > 0
      for: 1m
      labels:
        severity: page
      annotations:
        description: '{{ $labels.instance }} of job {{ $labels.job }} sent a response with an error code {{ $labels.http_status }}, path {{ $labels.path }}'
        summary: 'Instance {{ $labels.instance }} sent a response with an error code {{ $labels.http_status }}, path {{ $labels.path }}'

# Use the command to build::
 ./monitoring/Makefile -i prometheus -p false
```


- Configuring the integration of Alertmanager with e-mail:
```
$ cat ./monitoring/alertmanager/config.yml
global:
  slack_api_url: 'https://hooks.slack.com/services/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'


route:
  receiver: 'slack-notifications'
  routes:
    - receiver: 'slack-notifications'
      continue: true

    - receiver: 'email-notifications'
      continue: true

receivers:
- name: 'slack-notifications'
  slack_configs:
  - channel: '#vadim_martynov_gitlab_ci'

- name: 'email-notifications'
  email_configs:
  - to: 'me@gmail.com'
    from: 'alertalertmanager@gmail.com'
    smarthost: smtp.gmail.com:587
    auth_username: 'alertalertmanager@gmail.com'
    auth_identity: 'alertalertmanager@gmail.com'
    auth_password: '<password>'
```

- Implementation of automatic addition of the data source and created dashboards to the graphana:
An error occurs after the image is built:
```
Datasource named ${DS_PROMETHEUS} was not found
# or
Datasource named ${DS_PROMETHEUS_SERVER} was not found
```
This error occurs due to the presence of substitution of the datasource value in dashboards through the environment variable. This error does not appear when importing dashboards, but occurs when trying to add a dashboard to an automatic build.
For the solution, these variables have been changed.

Use the command to build:
```
 ./monitoring/Makefile -i grafana -p false
```



---
# Monitoring-2
Done:
- Preparation of the environment;
- Logging of Docker containers;
- Collecting unstructured logs;
- Visualization of logs;
- Collecting structured logs;
- Distributed tracking;
- Complete tasks with *.


## Additional tasks:
- Finish parsing logs in Fluent:
```
<filter service.ui>
  @type parser
  format grok
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  </grok>
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IP:remote_addr} \| method=%{SPACE}%{WORD:method} \| response_status=%{INT:response_status:integer}
  </grok>
  key_name message
  reserve_data true
</filter>
```

- Troubleshooting:
[In the first error](https://github.com/Artemmkin/bugged-code/blob/master/post-py/post_app.py#L53), two different types are added together. You need to fix it on:
```
body = b'\x0c\x00\x00\x00\x01' + encoded_span
```
In the second error, you need to delete this [line](https://github.com/Artemmkin/bugged-code/blob/master/post-py/post_app.py#L167).


---
# Kubernetes-1
Done:
- Manually deploy kubernet components;
- Install calico;
- Complete tasks with *.


## Additional tasks:
- Create modules in terraform, for creating virtual machines in yandex. cloud:
  Before you start, you need to edit the file ```kubernetes/terraform/stage/terraform.tfvars.example```

  ```
  cd kubernetes/terraform/stage/
  cp terraform.tfvars.example terraform.tfvars

  # Creating Virtual machines:

  cd kubernetes/terraform/stage/
  terraform init
  terraform plan
  terraform apply -auto-approve
  ```

- Creating ansible playbook:
  Before you start, you need to download the roles:
  ```
  cd ./kubernetes/ansible && ansible-galaxy install geerlingguy.pip && ansible-galaxy install geerlingguy.docker
  ```

  After that, you need to create an inventory file:
  ```
  cd ./kubernetes/ansible
  python3 ./main.py --sa-json-path="/path/to/Yandex Cloud/key.json" --folder-id <folder-id> --list
  ```

  Creating kubernetus cluster:
  ```
  ansible-playbook ./playbooks/kubernetes_claster.yml
  ```
  



---
# Kubernetes-2
Done:
- Deploy a local environment to work with Kubernetes;
- Deploy Kubernetes in Yandex Cloud;
- Launch the reddit app in Kubernetes;
- Complete tasks with *.


## Additional tasks:
- Deploy the Kubernetes cluster in Yandex cloud using the Terraform module:
  Before you start, you need to edit the file ```kubernetes/terraform_k8s/stage/terraform.tfvars.example```

  ```
  cd kubernetes/terraform_k8s/stage/
  cp terraform.tfvars.example terraform.tfvars

  # Creating Virtual machines:

  cd kubernetes/terraform_k8s/stage/
  terraform init
  terraform plan
  terraform apply -auto-approve
  ```

