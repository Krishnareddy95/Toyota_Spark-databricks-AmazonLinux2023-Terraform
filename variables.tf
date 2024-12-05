variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be created."
  type        = string
  default     = "vpc-cd0d63aa"
}

variable "subnet_ids" {
  description = "List of public subnet IDs within the existing VPC"
  type        = list(string)
  default     = ["subnet-1636bd73", "subnet-f1d4d4db"]
}

variable "security_group_ids" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
  default     = ["sg-0084898c137316bd6"]
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
  default     = "databuck-fargate-cluster-test"
}

variable "task_cpu" {
  description = "CPU units for ECS task"
  type        = string
  default     = "8192"
}

variable "task_memory" {
  description = "Memory for ECS task"
  type        = string
  default     = "32768"
}

variable "container_image" {
  description = "Docker image for the application"
  type        = string
  default     = "public.ecr.aws/t5x8b9h8/toyota_amazonlinu2023_databricks_efs:latest"
}

variable "efs_file_system_id" {
  description = "EFS File System ID"
  type        = string
  default     = "fs-0b2a222921d311252"  # Default value, no prompt
}


variable "efs_mount_path" {
  description = "Path to mount EFS on container"
  type        = string
  default     = "/opt/efs"
}

variable "efs_scripts_volume_path" {
  description = "The path in the container to mount the EFS scripts volume."
  type        = string
  default     = "/opt/databuck/scripts"
}

variable "awslogs_group" {
  description = "The CloudWatch log group name for ECS logging."
  type        = string
  default     = "/ecs/databuck"
}

variable "awslogs_region" {
  description = "The AWS region for CloudWatch logs."
  type        = string
  default     = "us-east-1"
}

variable "awslogs_stream_prefix" {
  description = "The prefix for the CloudWatch log stream."
  type        = string
  default     = "ecs"
}

