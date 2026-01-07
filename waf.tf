#############################################
# WAFv2 (REGIONAL) - ALB header protection
#
# This is the WAF Classic (wafregional) replacement.
#
# Behaviour:
#   - Default action: BLOCK
#   - Allow only when header `fromcloudfront` exactly equals a shared secret
#     (typically a random string injected by CloudFront as a custom origin header)
#############################################

resource "aws_wafv2_web_acl" "alb" {
  count = var.enable_wafv2_alb_header_protection ? 1 : 0

  name  = coalesce(var.wafv2_web_acl_name, "alb-${var.name}")
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow_only_cloudfront_header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string         = var.alb_cloudfront_key
        positional_constraint = "EXACTLY"

        field_to_match {
          # NOTE: WAFv2 requires the header name to be lowercase.
          single_header {
            name = "fromcloudfront"
          }
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow_only_cloudfront_header"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = coalesce(var.wafv2_web_acl_metric_name, "alb-${var.name}")
    sampled_requests_enabled   = true
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.alb_cloudfront_key != null && var.alb_cloudfront_key != ""
      error_message = "enable_wafv2_alb_header_protection is true but alb_cloudfront_key is empty. Provide the shared secret header value that CloudFront injects (e.g. a random string)."
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  count = var.enable_wafv2_alb_header_protection ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb[0].arn

  lifecycle {
    precondition {
      condition     = var.alb_arn != null && var.alb_arn != ""
      error_message = "enable_wafv2_alb_header_protection is true but alb_arn is empty. Provide the ARN of the ALB you want to protect."
    }
  }
}
