resource "aws_lb_listener_rule" "green" {
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    host_header {
      values = [local.hostname_green]
    }
  }

  # Optional path condition
  condition {
    path_pattern {
      values = local.paths_final
    }
  }

  lifecycle {
    # CodeDeploy swaps the target group in the listener action during deployments.
    ignore_changes = [action[0].target_group_arn]
  }
}

resource "aws_lb_listener_rule" "blue" {
  count        = local.hostname_blue != "" ? 1 : 0
  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    host_header {
      values = [local.hostname_blue]
    }
  }

  condition {
    path_pattern {
      values = local.paths_final
    }
  }

  lifecycle {
    ignore_changes = [action[0].target_group_arn]
  }
}

resource "aws_lb_target_group" "green" {
  name                 = "${var.cluster_name}-${var.name}-green"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    path = var.healthcheck_path
    matcher = var.healthcheck_matcher
  }

  tags = local.tags
}

resource "aws_lb_target_group" "blue" {
  name                 = "${var.cluster_name}-${var.name}-blue"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    path = var.healthcheck_path
    matcher = var.healthcheck_matcher
  }

  tags = local.tags
}
