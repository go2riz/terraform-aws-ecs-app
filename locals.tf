locals {
  execution_role_arn_final = coalesce(var.execution_role_arn, var.task_role_arn)

  # Backwards compatible hostname resolution:
  # - Prefer explicit hostname/hostname_blue
  # - Otherwise take from hostnames list
  hostname_green = coalesce(var.hostname, try(var.hostnames[0], null))
  hostname_blue  = (
    (var.hostname_blue != null && var.hostname_blue != "") ? var.hostname_blue : try(var.hostnames[1], "")
  )

  # Backwards compatible path resolution:
  paths_final = length(var.paths) > 0 ? var.paths : [var.path]

  tags = merge(
    {
      "ManagedBy" = "Terraform"
      "Module"    = "terraform-aws-ecs-app"
      "Name"      = var.name
    },
    var.tags
  )
}
