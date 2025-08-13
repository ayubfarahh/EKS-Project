terraform {
  backend "s3" {
    bucket       = "terra-bucket-2048"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
  }
}
