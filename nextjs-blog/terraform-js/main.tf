provider "aws" {
    region = "au-southeast-2"
}

# S3 Bucket for stattic website
resource "aws_s3_bucket" "nextjs_bucket" {
    bucket = "nextjs-bucket-ss"
}

# Ownership Control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_control"{
    bucket = aws_s3_bucket.nextjs_bucket.id

    rule {
        object_ownership = "BucketOwnerPrefferred"
    }
}

# Unblock public access to S3
resource "aws_s3_bucket_public_access_block" "nextjs_public_access_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
    depends on = [
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
    ]
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
}

# bucket policy 
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" { 
    bucket = aws_s3_bucket.nextjs_bucket.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject"
            Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
        }]
    })
}