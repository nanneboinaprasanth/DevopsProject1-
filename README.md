# DevopsProject1

End-to-end DevOps project for provisioning infrastructure, configuring a Jenkins host, building a Dockerized web app, and deploying it to Kubernetes.

## Project Structure

```text
.
|-- ansible/      # Server configuration and Docker setup
|-- app/          # Simple Nginx web app and Docker assets
|-- jenkins/      # Jenkins CI/CD pipeline
|-- kubernetes/   # Kubernetes deployment, service, ingress, and supporting manifests
|-- terraform/    # AWS infrastructure as code
```

## What Is Included

### Ansible

- `ansible.cfg` configures Ansible defaults.
- `inventory` defines the Jenkins host group and host variables.
- `install-docker.yml` installs and starts Docker on the Jenkins server.

### App

- `index.html` is the sample web page.
- `Dockerfile` builds an Nginx image for the app.
- `.dockerignore` excludes unnecessary files from Docker builds.
- `docker-compose.yml` can run the app locally with Docker Compose.

### Jenkins

- `Jenkinsfile` defines the CI/CD pipeline:
  - clone the repository
  - build the Docker image
  - push the image to Docker Hub
  - deploy Kubernetes manifests

Update the placeholder Docker Hub and GitHub values before running the pipeline.

### Kubernetes

- `deployment.yml` deploys the app container.
- `service.yml` exposes the app service.
- `ingress.yml` configures HTTP routing.
- `namespace.yml`, `configmap.yml`, `hpa.yml`, `pdb.yml`, and `secrets.yml.example` provide supporting production-style configuration.

### Terraform

- `provider.tf` configures Terraform and the AWS provider.
- `main.tf` provisions the Jenkins EC2 instance and related resources.
- `security.tf` creates security group and IAM resources.
- `variables.tf` defines configurable inputs.
- `outputs.tf` prints useful deployment outputs.
- `backend.tf` contains backend configuration guidance.
- `terraform.tfvars.example`, `terraform.tfvars.staging`, and `terraform.tfvars.prod` provide environment examples.

## Basic Workflow

1. Provision infrastructure:

   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

2. Configure the Jenkins server:

   ```bash
   cd ansible
   ansible-playbook -i inventory install-docker.yml
   ```

3. Build the app image locally if needed:

   ```bash
   cd app
   docker build -t devops-project:v1 .
   ```

4. Deploy to Kubernetes:

   ```bash
   kubectl apply -f kubernetes/
   ```

5. Configure Jenkins to use `jenkins/Jenkinsfile` for automated build and deployment.

## Before Running

- Replace placeholder Docker Hub and GitHub values in the Jenkins and Kubernetes files.
- Configure AWS credentials for Terraform.
- Update Ansible `inventory` with your Jenkins server IP and SSH user.
- Ensure Jenkins has access to Docker, Docker Hub credentials, and a valid Kubernetes kubeconfig.
- Review security settings before using this in production.
