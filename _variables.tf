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
  description = "ARN of the ALB HTTPS listener where host/path-based rules will be created."
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
  default     = 256
}

variable "memory" {
  description = "Memory (MiB) for the container definition."
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Container port to expose in the task definition."
  type        = number
}

variable "port" {
  description = "Port for the ALB target groups."
  type        = number
  default     = 80
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

# --- Routing (ALB listener rules) ---
# Backwards compatible: set hostname/hostname_blue OR provide hostnames list.
variable "hostname" {
  description = "Primary hostname (green) used in the ALB listener rule host_header condition."
  type        = string
  default     = null

  validation {
    condition     = var.hostname != null || length(var.hostnames) > 0
    error_message = "You must set either hostname or hostnames (non-empty)."
  }
}

variable "hostname_blue" {
  description = "Secondary hostname (blue) used in the ALB listener rule host_header condition. Optional."
  type        = string
  default     = ""
}

variable "hostnames" {
  description = "Optional list of hostnames. If hostname/hostname_blue are not set, hostnames[0] is treated as green and hostnames[1] (if present) as blue."
  type        = list(string)
  default     = []
}

# Backwards compatible: set path OR provide paths list.
variable "path" {
  description = "ALB listener rule path pattern (e.g. /*)."
  type        = string
  default     = "/*"
}

variable "paths" {
  description = "Optional list of ALB path patterns. If empty, path is used."
  type        = list(string)
  default     = []
}

variable "service_health_check_grace_period_seconds" {
  description = "ECS service health check grace period in seconds (useful for slow start apps)."
  type        = number
  default     = 0
}

# --- Autoscaling (optional) ---
variable "autoscaling_min" {
  description = "Minimum number of tasks when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "autoscaling_max" {
  description = "Maximum number of tasks when autoscaling is enabled."
  type        = number
  default     = 4
}

variable "autoscaling_cpu" {
  description = "Enable target tracking autoscaling based on ECSServiceAverageCPUUtilization."
  type        = bool
  default     = false
}

variable "autoscaling_memory" {
  description = "Enable target tracking autoscaling based on ECSServiceAverageMemoryUtilization."
  type        = bool
  default     = false
}

variable "autoscaling_cpu_target" {
  description = "CPU utilization target for autoscaling (percent)."
  type        = number
  default     = 70
}

variable "autoscaling_memory_target" {
  description = "Memory utilization target for autoscaling (percent)."
  type        = number
  default     = 70
}

variable "autoscaling_scale_in_cooldown" {
  description = "Cooldown (seconds) for scale-in."
  type        = number
  default     = 60
}

variable "autoscaling_scale_out_cooldown" {
  description = "Cooldown (seconds) for scale-out."
  type        = number
  default     = 60
}

# --- Deprecated / kept for compatibility with older root modules ---
variable "hostname_redirects" {
  description = "DEPRECATED (front module concern). Kept for compatibility with older root modules."
  type        = string
  default     = ""
}

variable "hostname_create" {
  description = "DEPRECATED (front module concern). Kept for compatibility with older root modules."
  type        = bool
  default     = true
}

variable "alarm_sns_topics" {
  description = "DEPRECATED/Optional. Kept for compatibility; this module does not currently create CloudWatch alarms."
  type        = list(string)
  default     = []
}

variable "healthcheck_matcher" {
  description = "HTTP codes to match for ALB target group health checks (e.g. \"200\" or \"200-399\")."
  type        = string
  default     = "200"
}

# --- Logging / tags ---
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
