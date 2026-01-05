# terraform-aws-ecs-app

Terraform module that deploys an ECS service with CodeDeploy blue/green deployments behind an ALB, and creates a CloudFront distribution + Route53 records for host-based routing.

## Terraform / provider support

- Terraform: `>= 1.6` (module constraint)
- AWS provider: `>= 4, < 6`

## Key behaviors

- Creates **two** ALB target groups (blue / green) and two listener rules (host based).
- Creates an ECS service using **CodeDeploy** deployment controller.
- Creates a CloudFront distribution with `minimum_protocol_version = TLSv1.2_2021`.
- Creates Route53 CNAME records:
  - `hostname` → CloudFront
  - `hostname_blue` → CloudFront
  - `hostname_origin` → ALB DNS name

## Example

```hcl
module "app" {
  source = "git::https://github.com/go2riz/terraform-aws-ecs-app.git?ref=<tag>"

  name                 = "voome"
  vpc_id               = var.vpc_id
  cluster_name         = var.cluster_name

  # ALB integration
  alb_listener_https_arn = var.alb_listener_https_arn
  alb_dns_name           = var.alb_dns_name
  port                   = 80
  container_port          = 8080
  healthcheck_path        = "/health"

  # Task
  image        = var.image
  cpu          = 256
  memory       = 512
  task_role_arn = var.task_role_arn
  # execution_role_arn = var.execution_role_arn  # optional

  # DNS / CloudFront
  hosted_zone    = "example.com."
  hostname       = "voome.example.com"
  hostname_blue  = "voome-blue.example.com"
  hostname_origin = "voome-origin.example.com"
  certificate_arn = var.certificate_arn  # ACM in us-east-1
}
```

## Notes on `service_role_arn`

Modern ECS services typically use the **service-linked role** automatically. This module keeps a legacy `service_role_arn` input for backwards compatibility, but does **not** set `aws_ecs_service.iam_role` unless you explicitly enable it with `use_legacy_service_iam_role = true`.
