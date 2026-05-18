# End-to-End DevOps Project

This repository contains a complete DevOps infrastructure setup demonstrating modern practices for application deployment, orchestration, and infrastructure automation.

## 📁 Project Structure

### `ansible/`
Infrastructure automation and configuration management scripts
- **`install-docker.yml`** - Ansible playbook for automated Docker installation and setup on target hosts
- **`inventory`** - Hosts inventory file for Ansible defining the target machines and groups

### `app/`
Application source code and containerization
- **`Dockerfile`** - Docker image definition for building the application container
- **`index.html`** - Frontend web page serving as the application interface

### `jenkins/`
CI/CD pipeline configuration
- **`Jenkinsfile`** - Jenkins pipeline definition for automated build, test, and deployment workflows

### `kubernetes/`
Container orchestration and deployment configurations
- **`deployment.yml`** - Kubernetes deployment manifest defining application pods and replicas
- **`service.yml`** - Kubernetes service manifest for network exposure and load balancing
- **`ingress.yml`** - Kubernetes ingress manifest for external HTTP(S) routing

### `terraform/`
Infrastructure as Code for cloud resource provisioning
- **`main.tf`** - Primary Terraform configuration defining cloud resources
- **`variables.tf`** - Input variables for Terraform configurations
- **`outputs.tf`** - Output values from Terraform state (endpoints, IPs, etc.)

## 🚀 Technology Stack

- **Configuration Management:** Ansible
- **Containerization:** Docker
- **CI/CD:** Jenkins
- **Container Orchestration:** Kubernetes
- **Infrastructure as Code:** Terraform
- **Frontend:** HTML

## 📋 How to Use

1. **Setup Infrastructure:** Use Terraform to provision cloud resources
   ```bash
   cd terraform
   terraform plan
   terraform apply
   ```

2. **Configure Hosts:** Use Ansible to install and configure Docker on provisioned instances
   ```bash
   cd ansible
   ansible-playbook -i inventory install-docker.yml
   ```

3. **Build Application:** Docker image is built as part of the CI/CD pipeline
   ```bash
   cd app
   docker build -t myapp:latest .
   ```

4. **Deploy to Kubernetes:** Apply Kubernetes manifests to your cluster
   ```bash
   cd kubernetes
   kubectl apply -f deployment.yml
   kubectl apply -f service.yml
   kubectl apply -f ingress.yml
   ```

5. **Setup CI/CD:** Configure Jenkins with the provided Jenkinsfile for automated pipelines

## 🔄 DevOps Workflow

This project demonstrates a complete DevOps pipeline:
1. Code changes trigger Jenkins pipelines
2. Jenkins builds Docker containers
3. Terraform provisions infrastructure
4. Ansible configures servers
5. Kubernetes orchestrates containerized applications
6. Services are exposed via Ingress

## 📝 Notes

- Ensure all required tools (Terraform, Ansible, Docker, kubectl) are installed
- Configure appropriate cloud credentials for Terraform
- Update inventory and variable files with your environment details
- Review security configurations before deploying to production