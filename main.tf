terraform {
  required_providers {
    
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
        
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}
provider "local" {
  # Configuration options
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#bucket create
resource "aws_s3_bucket" "s3" {
  bucket = "${var.BucketName}"

  tags = {
    Name        = "${var.BucketName}"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "s3acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

#access identufy create
resource "aws_cloudfront_origin_access_identity" "Cfront" {
  comment = "Its me  "
}

#create aws route53 record
resource "aws_route53_record" "myrecord" {
  zone_id = var.HostedZoneId
  name    = var.DomainName
  type    = "A"
 # ttl     = "300"
  alias {
    name    = aws_cloudfront_distribution.myDistribution.domain_name
    zone_id = aws_cloudfront_distribution.myDistribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# create cloudFront distribution

locals {
  s3_origin_id = var.BucketName
}

resource "aws_cloudfront_distribution" "myDistribution" {
  
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cfront"
  price_class         = "PriceClass_200"

  aliases = [var.DomainName]
  
  origin {
    domain_name = aws_s3_bucket.s3.bucket_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.Cfront.id}"
    }  
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
 
   tags = {
    Environment = "test"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn = var.CertificateArn
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }

  depends_on = [
      aws_s3_bucket.s3    
  ]
}

#=============== s3 policy ==============================

resource "aws_s3_bucket_policy" "s3_policy" {
    bucket = aws_s3_bucket.s3.id
    policy = jsonencode({
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
      
        {
            Action = "s3:GetObject"
            Effect = "Allow"
            Principal = {
              AWS = aws_cloudfront_origin_access_identity.Cfront.iam_arn
            }
            Resource = [
                aws_s3_bucket.s3.arn,
                "${aws_s3_bucket.s3.arn}/*"
            ]
            Sid      = "statement1"
        }
      ]
      Version = "2008-10-17"
    })
  }


output "ID_CloudFront" {
  value       = aws_cloudfront_distribution.myDistribution.id
                 
     }
     



    