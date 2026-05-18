# ARCHITECTURE

## System Architecture

```
┌─────────────────────────────────────────┐
│        Developer Workflow                │
└────────────────┬────────────────────────┘
                 │
     ┌───────────┼───────────┐
     │           │           │
  Terraform   Ansible    Jenkins
     │           │           │
  AWS Cloud  Configuration  CI/CD
     │           │           │
     └───────────┼───────────┘
                 │
     ┌───────────┴───────────┐
     │                       │
   Docker              Kubernetes
  Registry            Orchestration
     │                       │
     └───────────┬───────────┘
                 │
           End Users