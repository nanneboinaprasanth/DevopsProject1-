# Configuration Reference

This file lists the main settings that should be reviewed before running the Terraform, Ansible, Jenkins, Docker, and Kubernetes parts of the project.

## Terraform

Terraform configuration is stored in `terraform/`.

### Main Variables

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `region` | string | `ap-south-1` | AWS region for resource deployment. |
| `environment` | string | `dev` | Environment name. Allowed values: `dev`, `stg`, `prod`. |
| `instance_type` | string | `t2.micro` | EC2 instance type for the Jenkins server. |
| `instance_count` | number | `1` | Number of Jenkins EC2 instances. |
| `ssh_cidr` | string | `0.0.0.0/0` | CIDR allowed to access SSH. Restrict this for real deployments. |
| `enable_monitoring` | bool | `true` | Enables CloudWatch monitoring resources. |
| `enable_detailed_monitoring` | bool | `false` | Enables detailed EC2 monitoring. |
| `enable_ebs_optimization` | bool | `false` | Enables EBS optimization where supported. |
| `root_volume_size` | number | `20` | Root volume size in GB. |
| `root_volume_type` | string | `gp3` | Root EBS volume type. |
| `tags` | map(string) | project defaults | Common tags applied to AWS resources. |

### Example Variable File

Use one of the sample tfvars files as a starting point:

```bash
cd terraform
terraform plan -var-file="terraform.tfvars.staging"
terraform apply -var-file="terraform.tfvars.staging"
```

Do not commit real secrets or private keys in tfvars files.

### Security Settings

Review `terraform/security.tf` before deploying:

- SSH access uses `var.ssh_cidr`.
- Jenkins UI uses TCP `8080`.
- HTTP and HTTPS use TCP `80` and `443`.
- Outbound traffic is currently open.

For production, set `ssh_cidr` to your own IP range instead of `0.0.0.0/0`.

## Ansible

Ansible configuration is stored in `ansible/`.

### Inventory

Update `ansible/inventory` with the Jenkins server details after Terraform creates the instance.

Example:

```ini
[jenkins]
jenkins_server ansible_host=<JENKINS_PUBLIC_IP> ansible_user=ubuntu

[jenkins:vars]
ansible_python_interpreter=/usr/bin/python3
docker_version=latest
docker_users=jenkins
enable_docker_service=true
docker_package=docker
docker_service=docker
```

### Ansible Defaults

`ansible/ansible.cfg` sets:

- `inventory = ./inventory`
- `host_key_checking = False`
- SSH connection reuse and pipelining
- command timeout

## Jenkins

Jenkins pipeline configuration is stored in `jenkins/Jenkinsfile`.

### Required Updates

Replace these placeholders before running the pipeline:

| Setting | Current Placeholder | Replace With |
| --- | --- | --- |
| `DOCKER_USER` | `yourdockerhubusername` | Your Docker Hub username or registry namespace. |
| Git URL | `https://github.com/yourusername/end-to-end-devops-project.git` | This repository URL. |
| Image tag | `v1` | Keep `v1` or change to your release/versioning strategy. |

### Jenkins Agent Requirements

The Jenkins agent must have:

- Docker installed and running.
- Docker registry login or Jenkins credentials configured.
- `kubectl` installed.
- Kubernetes kubeconfig access for the target cluster.

## Docker

Application container configuration is stored in `app/`.

### Image

The app image is built from:

```text
app/Dockerfile
```

The Jenkinsfile currently builds:

```text
$DOCKER_USER/devops-project:v1
```

The image in `kubernetes/deployment.yml` must match the image pushed by Jenkins.

### Local Run

If using Docker Compose:

```bash
cd app
docker compose up --build
```

## Kubernetes

Kubernetes manifests are stored in `kubernetes/`.

### Core Manifests

| File | Purpose |
| --- | --- |
| `deployment.yml` | Runs the app pods. |
| `service.yml` | Exposes the app on port `80`. |
| `ingress.yml` | Routes HTTP traffic to the service. |

### Supporting Manifests

| File | Purpose |
| --- | --- |
| `namespace.yml` | Defines the `devops` namespace. |
| `configmap.yml` | Stores non-secret app configuration. |
| `hpa.yml` | Autoscaling configuration. |
| `pdb.yml` | Pod disruption budget. |
| `secrets.yml.example` | Template for Kubernetes secrets. |

### Current App Deployment Values

| Setting | Value |
| --- | --- |
| Deployment name | `devops-deployment` |
| App label | `devops-app` |
| Container name | `devops-container` |
| Container port | `80` |
| Replicas | `2` |
| Service type | `LoadBalancer` |
| Service port | `80` |
| Image | `yourdockerhubusername/devops-project:v1` |

### HPA Values

| Setting | Value |
| --- | --- |
| Min replicas | `2` |
| Max replicas | `10` |
| CPU target | `70%` |
| Memory target | `80%` |

## Secrets

Do not commit real secret values. Store sensitive data in:

- Jenkins credentials for Docker Hub and kubeconfig.
- AWS credential profiles, environment variables, or a secure CI secret store.
- Kubernetes `Secret` objects created from private local files.

Use `kubernetes/secrets.yml.example` only as a template.
