###################################################
# Real-time Monitoring Subscription for CloudFront Distribution
###################################################

resource "aws_cloudfront_monitoring_subscription" "this" {
  distribution_id = aws_cloudfront_distribution.this.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.monitoring_realtime_metrics_enabled ? "Enabled" : "Disabled"
    }
  }
}
