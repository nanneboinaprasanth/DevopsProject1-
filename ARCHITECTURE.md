# Architecture

This project demonstrates a small end-to-end DevOps workflow: AWS infrastructure is provisioned with Terraform, the Jenkins host is configured with Ansible, the application is packaged with Docker, and Kubernetes runs the deployed container.

## High-Level Flow

```text
Developer
   |
   v
GitHub Repository
   |
   v
Jenkins Pipeline
   |
   +--> Docker build from app/
   |
   +--> Docker image push to registry
   |
   +--> kubectl apply kubernetes/
   |
   v
Kubernetes Cluster
   |
   v
End Users
```

## Infrastructure Flow

```text
Terraform
   |
   +--> AWS provider configuration
   +--> Jenkins EC2 instance
   +--> Security group rules
   +--> IAM role and instance profile
   +--> Optional Elastic IP and CloudWatch alarm

Ansible
   |
   +--> Reads inventory
   +--> Connects to Jenkins host
   +--> Installs Docker
   +--> Starts Docker service
```

## CI/CD Flow

```text
Source Code Change
   |
   v
Jenkinsfile
   |
   +--> Clone repository
   +--> Build Docker image
   +--> Push Docker image
   +--> Deploy Kubernetes manifests
   |
   v
Running Application
```

## Component Responsibilities

### `terraform/`

Terraform owns cloud infrastructure. It provisions AWS resources needed for the Jenkins server and related access/security configuration.

Key files:

- `provider.tf` configures Terraform and the AWS provider.
- `main.tf` defines the Jenkins EC2 instance and supporting resources.
- `security.tf` defines security group and IAM resources.
- `variables.tf` defines configurable values.
- `outputs.tf` exposes useful values such as public IPs and Jenkins URL.

### `ansible/`

Ansible configures the provisioned Jenkins server after Terraform creates it.

Key files:

- `ansible.cfg` sets Ansible defaults.
- `inventory` defines the Jenkins host.
- `install-docker.yml` installs and starts Docker.

### `app/`

The app folder contains a simple static web application served by Nginx.

Key files:

- `index.html` is the web page.
- `Dockerfile` builds the Nginx image.
- `docker-compose.yml` can run the app locally.

### `jenkins/`

Jenkins handles automation for build and deployment.

Key file:

- `Jenkinsfile` defines the pipeline stages for clone, Docker build, Docker push, and Kubernetes deployment.

### `kubernetes/`

Kubernetes runs and exposes the application container.

Key files:

- `deployment.yml` manages app pods and replicas.
- `service.yml` exposes the pods inside or outside the cluster.
- `ingress.yml` routes HTTP traffic.
- `namespace.yml`, `configmap.yml`, `hpa.yml`, `pdb.yml`, and `secrets.yml.example` provide supporting environment and reliability configuration.

## Runtime Dependencies

The architecture expects these tools or services to be available:

- AWS account and credentials for Terraform.
- SSH access from the Ansible control machine to the Jenkins host.
- Jenkins agent with Docker and `kubectl` access.
- Docker registry credentials for image push.
- Kubernetes cluster credentials for deployment.

## Important Configuration Points

- Replace placeholder GitHub and Docker Hub values in `jenkins/Jenkinsfile`.
- Make sure the Kubernetes deployment image matches the image pushed by Jenkins.
- Update `ansible/inventory` with the real Jenkins server host details.
- Review security group CIDR ranges before exposing SSH or Jenkins.
- Store secrets in Jenkins credentials or Kubernetes secrets, not directly in committed files.
