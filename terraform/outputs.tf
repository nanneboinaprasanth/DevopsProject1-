output "instance_ids" {
  description = "Jenkins EC2 instance IDs"
  value       = aws_instance.jenkins[*].id
}

output "instance_public_ips" {
  description = "Jenkins EC2 instance public IP addresses"
  value       = aws_instance.jenkins[*].public_ip
}

output "instance_private_ips" {
  description = "Jenkins EC2 instance private IP addresses"
  value       = aws_instance.jenkins[*].private_ip
}

output "elastic_ips" {
  description = "Elastic IPs associated with Jenkins instances"
  value       = aws_eip.jenkins[*].public_ip
}

output "security_group_id" {
  description = "Security group ID for Jenkins server"
  value       = aws_security_group.jenkins.id
}

output "security_group_name" {
  description = "Security group name for Jenkins server"
  value       = aws_security_group.jenkins.name
}

output "iam_role_arn" {
  description = "ARN of Jenkins IAM role"
  value       = aws_iam_role.jenkins_role.arn
}

output "jenkins_url" {
  description = "Jenkins server URL"
  value       = "http://${aws_instance.jenkins[0].public_ip}:8080"
}

output "ssh_connection_string" {
  description = "SSH connection string for Jenkins server"
  value       = "ssh -i /path/to/key.pem ubuntu@${aws_instance.jenkins[0].public_ip}"
}

output "terraform_version" {
  description = "Terraform version used"
  value       = terraform.version
}

output "aws_region" {
  description = "AWS region where resources are created"
  value       = var.region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}