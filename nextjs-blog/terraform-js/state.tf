terraform {
    backend "s3" {
        bucket = "ty-my-terraform-state"
        key = "global/s3/terraform.tfstate"
        region = "au-southeast-2"
        dynamodb_table = "ty-s3-tf-table"
    }
}