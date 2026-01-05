resource "aws_ecs_service" "default" {
  name            = var.name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = var.desired_count

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
    ignore_changes = [task_definition, load_balancer]
  }

  tags = local.tags
}
