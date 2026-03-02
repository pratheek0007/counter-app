# ECS Auto Scaling Configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VARIABLES

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 5
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 80
}

variable "scale_out_cooldown" {
  description = "Seconds to wait before scaling out again"
  type        = number
  default     = 60
}

variable "scale_in_cooldown" {
  description = "Seconds to wait before scaling in again"
  type        = number
  default     = 300
}

# DATA SOURCES

data "aws_ecs_service" "this" {
  name    = var.service_name
  cluster = var.cluster_name
}


# RESOURCES

# Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [data.aws_ecs_service.this]
}

# CPU-based Target Tracking Scaling Policy
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${var.service_name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.target_cpu_utilization
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# OUTPUTS

output "service_name" {
  value       = var.service_name
  description = "ECS service name"
}

output "cluster_name" {
  value       = var.cluster_name
  description = "ECS cluster name"
}

output "min_tasks" {
  value       = var.min_capacity
  description = "Minimum number of tasks"
}

output "max_tasks" {
  value       = var.max_capacity
  description = "Maximum number of tasks"
}

output "target_cpu" {
  value       = "${var.target_cpu_utilization}%"
  description = "Target CPU utilization"
}

output "scaling_policy_arn" {
  value       = aws_appautoscaling_policy.ecs_policy_cpu.arn
  description = "ARN of the scaling policy"
}

output "scaling_policy_name" {
  value       = aws_appautoscaling_policy.ecs_policy_cpu.name
  description = "Name of the scaling policy"
}
