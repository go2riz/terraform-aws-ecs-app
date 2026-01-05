resource "aws_cloudwatch_log_group" "default" {
  name              = "ecs-${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = local.tags
}
