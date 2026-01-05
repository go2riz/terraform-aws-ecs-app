output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.default.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the task definition."
  value       = aws_ecs_task_definition.default.arn
}

output "target_group_green_arn" {
  description = "ARN of the green target group."
  value       = aws_lb_target_group.green.arn
}

output "target_group_blue_arn" {
  description = "ARN of the blue target group."
  value       = aws_lb_target_group.blue.arn
}

output "listener_rule_green_arn" {
  description = "ARN of the green listener rule."
  value       = aws_lb_listener_rule.green.arn
}

output "listener_rule_blue_arn" {
  description = "ARN of the blue listener rule (if created)."
  value       = try(aws_lb_listener_rule.blue[0].arn, null)
}

output "codedeploy_app_name" {
  description = "CodeDeploy application name."
  value       = aws_codedeploy_app.ecs.name
}

output "codedeploy_deployment_group_name" {
  description = "CodeDeploy deployment group name."
  value       = aws_codedeploy_deployment_group.ecs.deployment_group_name
}
