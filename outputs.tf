output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.default.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the task definition."
  value       = aws_ecs_task_definition.default.arn
}

output "target_group_green_arn" {
  description = "ARN of the green target group."
  value       = aws_lb_target_group.green.arn
}

output "target_group_blue_arn" {
  description = "ARN of the blue target group."
  value       = aws_lb_target_group.blue.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.default.id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.default.domain_name
}

output "route53_record_hostname" {
  description = "Route53 record name for the primary hostname."
  value       = aws_route53_record.hostname.fqdn
}

output "route53_record_hostname_blue" {
  description = "Route53 record name for the blue hostname."
  value       = aws_route53_record.hostname_blue.fqdn
}

output "route53_record_hostname_origin" {
  description = "Route53 record name for the origin hostname."
  value       = aws_route53_record.hostname_origin.fqdn
}
