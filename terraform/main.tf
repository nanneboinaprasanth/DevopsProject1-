# Data source for latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# EC2 Instance for Jenkins
resource "aws_instance" "jenkins" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.jenkins.name]
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
  associate_public_ip_address = true
  ebs_optimized               = var.enable_ebs_optimization
  monitoring                  = var.enable_detailed_monitoring

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "jenkins-root-volume"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring = var.enable_monitoring

  tags = merge(
    local.common_tags,
    {
      Name = "Jenkins-Server-${count.index + 1}"
      Role = "CI/CD"
    }
  )

  depends_on = [
    aws_iam_instance_profile.jenkins_profile,
    aws_security_group.jenkins
  ]
}

# Elastic IP for Jenkins (optional, for static IP)
resource "aws_eip" "jenkins" {
  count    = var.instance_count
  instance = aws_instance.jenkins[count.index].id
  domain   = "vpc"

  tags = {
    Name = "jenkins-eip-${count.index + 1}"
  }

  depends_on = [aws_instance.jenkins]
}

# CloudWatch CPU Alarm
resource "aws_cloudwatch_metric_alarm" "jenkins_cpu" {
  count               = var.instance_count
  alarm_name          = "jenkins-cpu-utilization-${count.index + 1}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when Jenkins CPU exceeds 80%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.jenkins[count.index].id
  }
}