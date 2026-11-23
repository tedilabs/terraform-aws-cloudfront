provider "aws" {
  region = "us-east-1"
}


###################################################
# CloudFront Distribution
###################################################

module "distribution" {
  source = "../../modules/distribution"
  # source  = "tedilabs/cloudfront/aws//modules/distribution"
  # version = "~> 0.7.0"

  name        = "example"
  description = "Managed by Terraform."

  custom_origins = {
    "api" = {
      host = "api.example.com"
    }
  }
  default_behavior = {
    target_origin = "api"

    # AWS managed cache policy: `Managed-CachingOptimized`
    cache_policy = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  tags = {
    "project" = "terraform-aws-cloudfront-examples"
  }
}
