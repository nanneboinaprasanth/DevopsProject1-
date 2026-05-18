# Setup Guide

This guide walks through the basic setup for the DevopsProject1 repository: provision AWS infrastructure, configure the Jenkins host, build the app image, and deploy to Kubernetes.

## Prerequisites

Install and configure these tools before starting:

- Git
- Terraform 1.0 or newer
- AWS CLI v2
- Ansible
- Docker
- Docker Compose
- kubectl
- Jenkins with Docker and kubectl access

You also need:

- An AWS account and credentials.
- A Docker Hub account or another container registry.
- Access to a Kubernetes cluster.
- SSH access to the Jenkins EC2 instance after Terraform creates it.

## 1. Clone The Repository

```bash
git clone https://github.com/nanneboinaprasanth/DevopsProject1-.git
cd DevopsProject1-
```

## 2. Configure AWS

```bash
aws configure
```

Use the same region that Terraform uses. The default project region is:

```text
ap-south-1
```

## 3. Provision Infrastructure With Terraform

```bash
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example"
```

For staging or production-style values, review and use:

```bash
terraform.tfvars.staging
terraform.tfvars.prod
```

After apply completes, note the Jenkins public IP:

```bash
terraform output
```

## 4. Configure The Jenkins Host With Ansible

Update `ansible/inventory` with the Jenkins EC2 public IP.

Example:

```ini
[jenkins]
jenkins_server ansible_host=<JENKINS_PUBLIC_IP> ansible_user=ubuntu
```

Then run:

```bash
cd ../ansible
ansible-playbook -i inventory install-docker.yml
```

Verify Docker:

```bash
ansible -i inventory jenkins -m shell -a "docker --version"
```

## 5. Build And Test The App Locally

```bash
cd ../app
docker build -t devops-project:v1 .
```

If using Docker Compose:

```bash
docker compose up --build
```

## 6. Update Jenkins And Kubernetes Image Values

Before running Jenkins, replace placeholder values.

In `jenkins/Jenkinsfile`:

```text
DOCKER_USER = "yourdockerhubusername"
git 'https://github.com/yourusername/end-to-end-devops-project.git'
```

Use your Docker Hub username and this repository URL:

```text
https://github.com/nanneboinaprasanth/DevopsProject1-.git
```

In `kubernetes/deployment.yml`, update the image:

```text
yourdockerhubusername/devops-project:v1
```

It must match the image Jenkins builds and pushes.

## 7. Configure Jenkins

Create or configure a Jenkins pipeline job that uses:

```text
jenkins/Jenkinsfile
```

Make sure the Jenkins agent has:

- Docker installed and permission to run Docker commands.
- Docker registry credentials.
- kubectl installed.
- kubeconfig access to the Kubernetes cluster.

## 8. Deploy To Kubernetes

You can deploy all manifests together:

```bash
kubectl apply -f kubernetes/
```

Or apply the key manifests in order:

```bash
kubectl apply -f kubernetes/namespace.yml
kubectl apply -f kubernetes/configmap.yml
kubectl apply -f kubernetes/deployment.yml
kubectl apply -f kubernetes/service.yml
kubectl apply -f kubernetes/ingress.yml
kubectl apply -f kubernetes/hpa.yml
kubectl apply -f kubernetes/pdb.yml
```

Check the deployment:

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

## Verification Checklist

- Terraform initialized successfully.
- AWS resources were created.
- Jenkins EC2 public IP is available.
- Ansible can connect to the Jenkins host.
- Docker is installed on the Jenkins host.
- Jenkins can build and push the Docker image.
- Kubernetes manifests apply successfully.
- Pods are running.
- Service or ingress exposes the app.

## Cleanup

To remove AWS infrastructure created by Terraform:

```bash
cd terraform
terraform destroy
```

Delete Kubernetes resources if needed:

```bash
kubectl delete -f kubernetes/
```
