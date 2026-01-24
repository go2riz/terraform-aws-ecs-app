locals {
  autoscaling = {
    cpu = {
      enabled      = var.autoscaling_cpu
      metric_type  = "ECSServiceAverageCPUUtilization"
      target_value = var.autoscaling_cpu_target
    }
    memory = {
      enabled      = var.autoscaling_memory
      metric_type  = "ECSServiceAverageMemoryUtilization"
      target_value = var.autoscaling_memory_target
    }
  }

  autoscaling_policies = { for k, v in local.autoscaling : k => v if v.enabled }
  autoscaling_enabled  = length(local.autoscaling_policies) > 0
}

# Create the scalable target only if any autoscaling is enabled
resource "aws_appautoscaling_target" "ecs" {
  for_each          = local.autoscaling_enabled ? { ecs = true } : {}
  max_capacity      = var.autoscaling_max
  min_capacity      = var.autoscaling_min
  resource_id       = "service/${var.cluster_name}/${aws_ecs_service.default.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  # ECS service exists before registering target
  depends_on = [aws_ecs_service.default]

  lifecycle {
    create_before_destroy = true
  }
}

# Optional but very helpful: wait a bit so target is fully "registered" before policies
# Requires hashicorp/time provider (see below).
resource "time_sleep" "autoscaling_propagation" {
  for_each        = aws_appautoscaling_target.ecs
  create_duration = "10s"
  depends_on      = [aws_appautoscaling_target.ecs]
}

# One policy resource for both CPU & Memory
resource "aws_appautoscaling_policy" "tt" {
  for_each          = local.autoscaling_policies
  name              = "${var.name}-${each.key}"
  policy_type       = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.ecs["ecs"].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs["ecs"].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs["ecs"].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = each.value.metric_type
    }

    target_value       = each.value.target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }

  depends_on = [time_sleep.autoscaling_propagation]
}
