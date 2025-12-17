# == REQUIRED VARS

variable "name" {
  type        = string
  description = "Name of your ECS service"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "port" {
  type    = number
  default = 80
}

variable "memory" {
  type    = number
  default = 512
}

variable "cpu" {
  type    = number
  default = 0
}

variable "hostname" {
  type = string
}
variable "hostname_blue" {
  type = string
}
variable "hostname_origin" {
  type = string
}

variable "healthcheck_path" {
  type    = string
  default = "/"
}

variable "hosted_zone" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_role_arn" {
  type = string
}
variable "task_role_arn" {
  type = string
}

variable "image" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_listener_https_arn" {
  type = string
}
variable "alb_dns_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}
