# Start Here

Welcome to DevopsProject1. This repository is a small end-to-end DevOps project that connects Terraform, Ansible, Docker, Jenkins, and Kubernetes into one deployment workflow.

## What This Project Does

```text
Terraform creates infrastructure
Ansible configures the Jenkins host
Docker packages the web app
Jenkins builds and deploys
Kubernetes runs the app
```

## Recommended Reading Order

1. `README.md` - project overview and folder summary.
2. `START_HERE.md` - quick orientation.
3. `SETUP.md` - step-by-step setup.
4. `CONFIG.md` - configuration values and placeholders.
5. `ARCHITECTURE.md` - system flow and component responsibilities.
6. `TROUBLESHOOTING.md` - common problems and fixes.

## Main Folders

| Folder | Purpose |
| --- | --- |
| `terraform/` | AWS infrastructure for the Jenkins server and related resources. |
| `ansible/` | Jenkins host configuration, including Docker installation. |
| `app/` | Static Nginx app, Dockerfile, and Docker Compose file. |
| `jenkins/` | Jenkins pipeline definition. |
| `kubernetes/` | App deployment, service, ingress, autoscaling, and support manifests. |

## First Things To Update

Before running the project, review these placeholders:

- Docker Hub username in `jenkins/Jenkinsfile`.
- GitHub repository URL in `jenkins/Jenkinsfile`.
- Container image in `kubernetes/deployment.yml`.
- Jenkins server IP and SSH user in `ansible/inventory`.
- Terraform values in `terraform/terraform.tfvars.example` or another tfvars file.

## Quick Command Path

Provision infrastructure:

```bash
cd terraform
terraform init
terraform apply -var-file="terraform.tfvars.example"
```

Configure Jenkins host:

```bash
cd ../ansible
ansible-playbook -i inventory install-docker.yml
```

Build app locally:

```bash
cd ../app
docker build -t devops-project:v1 .
```

Deploy to Kubernetes:

```bash
cd ..
kubectl apply -f kubernetes/
```

## Important Notes

- Do not commit real AWS keys, kubeconfig files, Docker passwords, or Kubernetes secrets.
- Restrict `ssh_cidr` before using this outside a lab environment.
- Make sure Jenkins has Docker registry credentials and Kubernetes cluster access.
- Keep the Docker image name consistent between Jenkins and Kubernetes.

For full setup details, continue with `SETUP.md`.
