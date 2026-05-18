# Configuration Reference

Detailed configuration options for all components.

## Terraform Configuration

### Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | ap-south-1 | AWS region |
| `environment` | string | dev | Environment name |
| `instance_type` | string | t2.micro | EC2 instance type |
| `instance_count` | number | 1 | Number of instances |

### Security Group Rules

- Inbound: TCP 22 (SSH)
- Inbound: TCP 8080 (Jenkins)
- Inbound: TCP 80 (HTTP)
- Inbound: TCP 443 (HTTPS)
- Outbound: All traffic allowed

## Ansible Configuration

### Inventory

```ini
[jenkins]
jenkins_server ansible_host=<IP> ansible_user=ubuntu

[jenkins:vars]
docker_version=latest
```

## Kubernetes Configuration

### Namespace

```yaml
name: devops
environment: production
```

### Deployment Specs

- Image: yourdockerhubusername/devops-project:v1
- Replicas: 2
- Resource Limits: CPU 500m, Memory 512Mi
- Resource Requests: CPU 250m, Memory 256Mi

### Health Probes

- Liveness: HTTP GET /, 10s initial delay, 30s period
- Readiness: HTTP GET /, 5s initial delay, 10s period

### Service

- Type: LoadBalancer
- Port: 80
- Target Port: 80

### HPA

- Min Replicas: 2
- Max Replicas: 10
- CPU Target: 70%
- Memory Target: 80%