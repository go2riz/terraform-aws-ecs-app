variable "vpc_id" {
  description = "VPC ID where the target groups will be created."
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name."
  type        = string
}

variable "service_role_arn" {
  description = "(Legacy) IAM role ARN that allows ECS to call ELB on your behalf. Leave null/empty for modern ECS service-linked-role behavior."
  type        = string
  default     = null
}

variable "use_legacy_service_iam_role" {
  description = "Whether to set aws_ecs_service.iam_role from service_role_arn (legacy behavior). For most modern ECS setups this should be false."
  type        = bool
  default     = false
}

variable "task_role_arn" {
  description = "IAM role ARN for the task (task role)."
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution. If null, falls back to task_role_arn for backwards compatibility."
  type        = string
  default     = null
}

variable "alb_listener_https_arn" {
  description = "ARN of the ALB HTTPS listener where host-based rules will be created."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB (e.g. internal-xxx.elb.amazonaws.com)."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN to attach to the CloudFront distribution. Must be in us-east-1."
  type        = string
}

variable "name" {
  description = "Service/module name. Used for ECS family, CodeDeploy app/group, log group name, etc."
  type        = string
}

variable "image" {
  description = "Container image URI (e.g. ECR or Docker Hub)."
  type        = string
}

variable "cpu" {
  description = "CPU units for the container definition."
  type        = number
}

variable "memory" {
  description = "Memory (MiB) for the container definition."
  type        = number
}

variable "container_port" {
  description = "Container port to expose in the task definition."
  type        = number
}

variable "port" {
  description = "Port for the ALB target groups."
  type        = number
}

variable "healthcheck_path" {
  description = "Health check path for the ALB target groups."
  type        = string
  default     = "/"
}

variable "desired_count" {
  description = "Desired number of tasks to run."
  type        = number
  default     = 1
}

variable "hosted_zone" {
  description = "Route53 hosted zone name (e.g. example.com.)."
  type        = string
}

variable "hostname" {
  description = "Primary hostname (green) that will route to the service."
  type        = string
}

variable "hostname_blue" {
  description = "Secondary hostname (blue) that will route to the blue target group during blue/green deployments."
  type        = string
}

variable "hostname_origin" {
  description = "Origin hostname used by CloudFront to reach the ALB. A CNAME will be created pointing to alb_dns_name."
  type        = string
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to created resources where supported."
  type        = map(string)
  default     = {}
}
