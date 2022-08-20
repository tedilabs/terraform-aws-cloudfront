###################################################
# Real-time Monitoring Subscription for CloudFront Distribution
###################################################

resource "aws_cloudfront_monitoring_subscription" "this" {
  count = var.monitoring_realtime_metrics_enabled ? 1 : 0

  distribution_id = aws_cloudfront_distribution.this.id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = "Enabled"
    }
  }
}
