terraform {
  backend "s3" {
    bucket = "my-tf-test-bucketxxxaxaxaxaxasasassd-ec2ech" # Replace with your actual S3 bucket name
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"
  }
}
