terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Create S3 buckets

locals {
  bucket_names = [
    "devops-way-artifacts-dev",
    "devops-way-logs-001",
    "anhelina-devops-state-store",
    "devops-way-ci-cache",
    "devops-way-tf-backend"
  ]
}

resource "aws_s3_bucket" "project_buckets" {
  for_each      = toset(local.bucket_names)
  bucket        = each.value
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  for_each = aws_s3_bucket.project_buckets
  bucket   = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
# Create parameter
resource "aws_ssm_parameter" "project_param" {
  name  = "/devops/way/config"
  type  = "String"
  value = "example_value"
}

# Create container IAM User
resource "aws_iam_user" "devops_way_user" {
  name = "devops-way-aws-user"
}

# Create container IAM Policy
resource "aws_iam_policy" "devops_way_policy" {
  name        = "devops-way-aws-policy"
  description = "Policy for DevOps Way AWS User"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters",
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Attach Policy to User
resource "aws_iam_user_policy_attachment" "devops_way_user_policy_attachment" {
  user       = aws_iam_user.devops_way_user.name
  policy_arn = aws_iam_policy.devops_way_policy.arn
}

# Outputs
output "s3_bucket_names" {
  value = [for b in aws_s3_bucket.project_buckets : b.bucket]
}

output "ssm_parameter_name" {
  value = aws_ssm_parameter.project_param.name
}

output "iam_user_name" {
  value = aws_iam_user.devops_way_user.name
}

output "iam_policy_arn" {
  value = aws_iam_policy.devops_way_policy.arn
}
