output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.databuck_cluster-test.id
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS Task Definition"
  value       = aws_ecs_task_definition.databuck_task-test.arn
}

output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.databuck_service-test.name
}

