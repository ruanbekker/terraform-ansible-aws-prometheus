terraform {
  backend "s3" {
    encrypt = true
    bucket = "my-remote-state-bucket"
    key = "terraform/prometheus-a-dev/terraform.tfstate"
    region = "eu-west-1"
    profile = "dev"
    shared_credentials_file = "~/.aws/credentials"
    dynamodb_table = "terraform-lock-table"
  }
}
