# terraform-aws-cloudfront

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-cloudfront?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-cloudfront?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates CloudFront related resources on AWS.

- [cache-policy](./modules/cache-policy)
- [distribution](./modules/distribution)
- [key-value-store](./modules/key-value-store)
- [origin-access-control](./modules/origin-access-control)
- [origin-request-policy](./modules/origin-request-policy)
- [response-headers-policy](./modules/response-headers-policy)
- [vpc-origin](./modules/vpc-origin)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-cloudfront) were written to manage the following AWS Services with Terraform.

- **AWS CloudFront**
  - Distribution
  - Key-value Store
  - Real-time Log Configuration (Comming soon!)
  - Origins
    - Custom Origin
    - S3 Origin
    - VPC Origin
  - Origin Access
    - Origin Access Control
  - Policies
    - Cache Policy
    - Origin Request Policy
    - Resposne Headers Policy


## Examples

### CloudFront

- [cloudfront-distribution-simple](./examples/cloudfront-distribution-simple/)
- [cloudfront-policies](./examples/cloudfront-policies/)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-cloudfront). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2022-2025, [Byungjin Park](https://www.posquit0.com).
