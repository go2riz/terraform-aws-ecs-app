# terraform-aws-ecs-app (service-only)

Terraform module that deploys an **ECS service** with **CodeDeploy blue/green deployments** behind an **ALB**.

This refactored version is **service-only** (no CloudFront / no Route53).  
For the CDN + DNS layer, pair it with your `terraform-aws-ecs-app-front` module.

## Terraform / provider support

- Terraform: `>= 1.3, < 2.0`
- AWS provider: `>= 4, < 6`

## What it creates

- Two ALB target groups: **green** and **blue**
- ALB listener rule(s) based on **host_header** (and optional **path_pattern**)
- ECS service using **CodeDeploy** deployment controller
- CodeDeploy application + deployment group for ECS blue/green
- CloudWatch Log Group for the container
- Optional ECS service autoscaling policies (CPU and/or memory target tracking)

## Example (Option A: front module + service module)

```hcl
module "app_front" {
  source = "git::https://github.com/go2riz/terraform-aws-ecs-app-front.git?ref=<tag>"
  # CloudFront + Route53 live here
  # ...
}

module "app" {
  source = "git::https://github.com/go2riz/terraform-aws-ecs-app.git?ref=<tag>"

  name         = "frontend"
  vpc_id       = var.vpc_id
  cluster_name = var.cluster_name

  alb_listener_https_arn = var.alb_listener_https_arn

  image          = var.image
  container_port = 80

  # Routing
  hostname      = "app.example.com"
  hostname_blue = "app-blue.example.com"
  path          = "/*"

  # Optional (defaults shown)
  cpu    = 256
  memory = 512
  port   = 80

  healthcheck_path = "/health"
  task_role_arn    = var.task_role_arn
  # execution_role_arn = var.execution_role_arn  # optional

  # Optional autoscaling
  autoscaling_min = 1
  autoscaling_max = 4
  autoscaling_cpu = true
}
```

## Notes on `service_role_arn`

Modern ECS services typically use the **service-linked role** automatically. This module keeps a legacy `service_role_arn` input for backwards compatibility, but does **not** set `aws_ecs_service.iam_role` unless you explicitly enable it with `use_legacy_service_iam_role = true`.
