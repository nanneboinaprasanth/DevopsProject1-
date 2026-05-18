# Setup Guide

Complete setup instructions for the End-to-End DevOps Project.

## Prerequisites

Ensure you have the following tools installed:

- **Terraform** (v1.0+): Infrastructure provisioning
- **Ansible** (2.9+): Configuration management
- **Docker** (20.10+): Container runtime
- **kubectl** (v1.20+): Kubernetes CLI
- **AWS CLI** (v2): AWS credential management
- **Git**: Version control

### Installation

#### macOS
```bash
brew install terraform ansible docker kubectl awscli
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y terraform ansible docker.io kubectl awscli
```

#### Windows
```powershell
choco install terraform ansible docker kubectl awscli
```

## Setup Steps

### 1. AWS Configuration

Configure AWS credentials:
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region: ap-south-1
# Enter default output format: json
```

### 2. Terraform Setup

```bash
cd terraform

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize Terraform
terraform init

# Plan infrastructure
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan

# Save outputs
terraform output > outputs.txt
```

**Note:** Save the Jenkins server's public IP from outputs for Ansible configuration.

### 3. Ansible Configuration

```bash
cd ansible

# Update inventory with Jenkins server details
nano inventory

# Run playbook
ansible-playbook -i inventory install-docker.yml -vv

# Verify Docker installation
ansible -i inventory jenkins -m shell -a "docker --version"
```

### 4. Docker Image Build

```bash
cd app

# Build Docker image
docker build -t yourdockerhubusername/devops-project:v1 .

# Test locally with docker-compose
docker-compose up -d
```

### 5. Kubernetes Deployment

```bash
cd kubernetes

kubectl apply -f namespace.yml
kubectl apply -f configmap.yml -n devops
kubectl apply -f deployment.yml -n devops
kubectl apply -f service.yml -n devops
kubectl apply -f ingress.yml -n devops
kubectl apply -f hpa.yml -n devops
```

## Verification Checklist

- [ ] Terraform state created successfully
- [ ] EC2 instance running
- [ ] Docker installed on Jenkins server
- [ ] Docker image built and pushed
- [ ] Kubernetes cluster accessible
- [ ] All pods running
- [ ] Service LoadBalancer working
- [ ] Ingress routing correctly
- [ ] Jenkins pipeline executing