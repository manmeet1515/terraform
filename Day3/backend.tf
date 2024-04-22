terraform {
  backend "s3" {
    bucket = "terraformbucket-test-456"
    key    = "manmeet/terraform.tfstate"
    region = "us-east-1"
  }
}
