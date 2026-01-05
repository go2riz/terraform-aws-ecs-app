resource "aws_ecs_service" "default" {
  name            = var.name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = var.desired_count

  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds > 0 ? var.service_health_check_grace_period_seconds : null

  # NOTE: Setting iam_role is legacy behavior. For most modern ECS + ALB deployments, rely on the service-linked role instead.
  iam_role = (
    var.use_legacy_service_iam_role && var.service_role_arn != null && var.service_role_arn != ""
  ) ? var.service_role_arn : null

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  lifecycle {
    # CodeDeploy and autoscaling typically mutate these fields.
    ignore_changes = [task_definition, load_balancer, desired_count]
  }

  # Ensure listener rules exist before creating the service so the target groups are ready.
  depends_on = [aws_lb_listener_rule.green]

  tags = local.tags
}
