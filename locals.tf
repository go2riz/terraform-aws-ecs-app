locals {
  execution_role_arn_final = coalesce(var.execution_role_arn, var.task_role_arn)

  tags = merge(
    {
      "ManagedBy" = "Terraform"
      "Module"    = "terraform-aws-ecs-app"
      "Name"      = var.name
    },
    var.tags
  )
}
