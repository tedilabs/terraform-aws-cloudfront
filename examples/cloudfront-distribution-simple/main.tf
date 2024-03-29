provider "aws" {
  region = "us-east-1"
}


###################################################
# CloudFront Distribution
###################################################

module "distribution" {
  source = "../../modules/distribution"
  # source  = "tedilabs/cloudfront/aws//modules/distribution"
  # version = "~> 0.2.0"

  name        = "example"
  description = "Managed by Terraform."

  custom_origins = {
    "api" = {
      host = "api.example.com"
    }
  }
  default_behavior = {
    target_origin = "api"
  }

  tags = {
    "project" = "terraform-aws-cloudfront-examples"
  }
}
