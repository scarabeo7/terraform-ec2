terraform {
  backend "s3" {
    bucket = "test-tarraform-backend"
    key    = "statefile"
    region = "eu-west-2"
  }
}
