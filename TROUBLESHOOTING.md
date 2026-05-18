# Troubleshooting

Use this guide when Terraform, Ansible, Docker, Jenkins, or Kubernetes steps fail.

## Quick Checks

Start with these commands:

```bash
git status
docker --version
terraform version
ansible --version
kubectl version --client
aws sts get-caller-identity
```

If one of these commands fails, fix that tool or credential setup first.

## Terraform

### `terraform init` Fails

Check that you are in the Terraform folder:

```bash
cd terraform
terraform init
```

If provider download fails, check network access and retry.

### AWS Credentials Not Found

Verify AWS credentials:

```bash
aws sts get-caller-identity
```

If it fails, configure credentials:

```bash
aws configure
```

### Invalid Region

The default region is:

```text
ap-south-1
```

Check `terraform/variables.tf` or your selected tfvars file.

### SSH Is Open To Everyone

The default `ssh_cidr` may be:

```text
0.0.0.0/0
```

For safer use, update it to your IP range in a tfvars file:

```hcl
ssh_cidr = "YOUR_PUBLIC_IP/32"
```

### Resource Already Exists

If AWS resources already exist, either import them or destroy/recreate carefully.

Example import pattern:

```bash
terraform import <resource_type>.<resource_name> <resource_id>
```

Do not delete cloud resources unless you are sure they are no longer needed.

## Ansible

### Host Is Unreachable

Check the inventory:

```bash
cat ansible/inventory
```

Ping the host:

```bash
cd ansible
ansible -i inventory jenkins -m ping -vvv
```

Common fixes:

- Use the correct Jenkins public IP.
- Use the correct SSH user, usually `ubuntu` for Ubuntu AMIs.
- Make sure port `22` is allowed in the security group.
- Make sure your SSH private key has correct permissions.

Linux/macOS key permission example:

```bash
chmod 600 ~/.ssh/jenkins-key.pem
```

### Docker Install Playbook Fails

Run with verbose output:

```bash
ansible-playbook -i inventory install-docker.yml -vvv
```

Then verify Docker manually:

```bash
ansible -i inventory jenkins -m shell -a "docker --version"
ansible -i inventory jenkins -m shell -a "systemctl status docker"
```

## Docker

### Docker Build Fails

Run from the repository root:

```bash
docker build -t devops-project:v1 app/
```

Or from inside `app/`:

```bash
cd app
docker build -t devops-project:v1 .
```

Use a no-cache build if needed:

```bash
docker build --no-cache -t devops-project:v1 app/
```

### Docker Push Fails

Login first:

```bash
docker login
```

Make sure the image name includes your Docker Hub username:

```bash
docker tag devops-project:v1 <dockerhub-user>/devops-project:v1
docker push <dockerhub-user>/devops-project:v1
```

## Jenkins

### Clone Stage Fails

Check the Git URL in `jenkins/Jenkinsfile`.

Current placeholder:

```text
https://github.com/yourusername/end-to-end-devops-project.git
```

Replace it with:

```text
https://github.com/nanneboinaprasanth/DevopsProject1-.git
```

### Docker Build Stage Fails

Make sure Docker is installed on the Jenkins agent:

```bash
docker --version
docker ps
```

If Jenkins cannot access Docker, add the Jenkins user to the Docker group or configure the agent with Docker access.

### Docker Push Stage Fails

Common causes:

- `DOCKER_USER` is still `yourdockerhubusername`.
- Jenkins is not logged in to Docker Hub.
- Docker Hub credentials are missing from Jenkins.
- The repository does not exist or the user does not have permission.

Use Jenkins credentials rather than hardcoding passwords.

### Kubernetes Deploy Stage Fails

Check that Jenkins can run:

```bash
kubectl get nodes
kubectl get namespaces
```

If this fails, configure kubeconfig for the Jenkins user or Jenkins agent.

## Kubernetes

### `kubectl apply` Fails

Validate that the cluster is reachable:

```bash
kubectl cluster-info
kubectl get nodes
```

Apply all manifests:

```bash
kubectl apply -f kubernetes/
```

If namespace-related errors appear, apply the namespace first:

```bash
kubectl apply -f kubernetes/namespace.yml
```

### ImagePullBackOff

Check the image in `kubernetes/deployment.yml`:

```text
yourdockerhubusername/devops-project:v1
```

It must match the image pushed by Jenkins.

Describe the pod:

```bash
kubectl describe pod <pod-name>
```

If the registry is private, create an image pull secret:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<password>
```

Then reference it from the deployment.

### CrashLoopBackOff

Check logs and events:

```bash
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

For this Nginx app, also confirm that `app/index.html` exists and that the Docker image built successfully.

### Service Has No External IP

Check the service:

```bash
kubectl get svc
kubectl describe svc devops-service
```

If `EXTERNAL-IP` stays pending, your cluster may not support `LoadBalancer` services. Use NodePort, port-forwarding, or a cloud load balancer integration.

Port-forward test:

```bash
kubectl port-forward svc/devops-service 8080:80
```

Open:

```text
http://localhost:8080
```

### Ingress Does Not Work

Check if an ingress controller is installed:

```bash
kubectl get pods -A | grep ingress
kubectl get ingress
```

The configured host is:

```text
devops.local
```

For local testing, add a hosts file entry pointing `devops.local` to your ingress/load balancer IP.

## Documentation And Config Mismatch

If commands in docs do not match your files, compare the current repository files:

```bash
git pull origin main
git status
```

Then check:

- `README.md` for overview.
- `START_HERE.md` for quick start.
- `SETUP.md` for setup steps.
- `CONFIG.md` for configuration values.
- `ARCHITECTURE.md` for system flow.
