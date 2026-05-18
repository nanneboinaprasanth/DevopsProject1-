# TROUBLESHOOTING

## Common Issues & Solutions

### Terraform

**Error: resource already exists**
```bash
terraform state rm aws_instance.jenkins-server
terraform import aws_instance.jenkins-server <instance-id>
```

### Ansible

**unreachable hosts**
```bash
ansible -i inventory all -m ping -v
chmod 600 ~/.ssh/jenkins-key.pem
```

### Docker

**Build fails**
```bash
docker build --no-cache -t test:latest .
```

### Kubernetes

**ImagePullBackOff**
```bash
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<password> \
  -n devops
```

**CrashLoopBackOff**
```bash
kubectl logs <pod-name> -n devops
kubectl describe pod <pod-name> -n devops
```

## More Help

See TROUBLESHOOTING.md for detailed solutions.