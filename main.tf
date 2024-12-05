provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_REGION
}


terraform {
  backend "s3" {
    bucket         = "ecs-emr"  # Replace with your S3 bucket name
    key            = "terraform/state/terraform.tfstate"  # Path in the bucket
    region         = "us-east-1"  # Replace with your S3 bucket's region
    encrypt        = true  # Enable server-side encryption
   # dynamodb_table = "terraform-locks"  # Replace with your DynamoDB table name (optional)
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "databuck_cluster-test" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "databuck_task-test" {
  family                   = "databuck_task-test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = "arn:aws:iam::187184905225:role/ECSExecutionRole"  # Replace with actual role ARN
  task_role_arn            = "arn:aws:iam::187184905225:role/ecsTaskExecutionRole"  # Replace with actual role ARN

  container_definitions = jsonencode([{
    name      = "databuck-container"
    image     = var.container_image
    cpu       = 8192
    memory    = 32768
    essential = true
    portMappings = [
      {
        containerPort = 8080
      }
    ]
  "environment": [
    {
      "name": "EFS_PATH",
      "value": "${var.efs_mount_path}"
    }
  ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.awslogs_group
        awslogs-region        = var.awslogs_region
        awslogs-stream-prefix = var.awslogs_stream_prefix
      }
    }
    mountPoints = [
       {
        sourceVolume  = "efs-volume"
        containerPath = var.efs_mount_path
      },
      {
        sourceVolume  = "efs-scripts-volume"
        containerPath = "/opt/databuck/scripts"
      }
    ]
  }])
  
   volume {
    name = "efs-volume"
    efs_volume_configuration {
      file_system_id     = var.efs_file_system_id
      transit_encryption = "ENABLED"
    }
  }

  # Volume for /scripts path
  volume {
    name = "efs-scripts-volume"
    efs_volume_configuration {
      file_system_id     = var.efs_file_system_id
      root_directory     = "/scripts_dbck"  # Mount the entire EFS file system
      transit_encryption = "ENABLED"
    }
  }
}

# ECS Fargate Service
resource "aws_ecs_service" "databuck_service-test" {
  name            = "databuck-service-test"
  cluster         = aws_ecs_cluster.databuck_cluster-test.id
  task_definition = aws_ecs_task_definition.databuck_task-test.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  enable_execute_command = true

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = true
  }

  # Attach Service Discovery
  # service_registries {
  #   registry_arn = aws_service_discovery_service.databuck_service.arn
  # }
}
