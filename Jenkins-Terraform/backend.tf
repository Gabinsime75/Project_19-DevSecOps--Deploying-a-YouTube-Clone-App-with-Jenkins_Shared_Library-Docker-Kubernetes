terraform {
  backend "s3" {
    bucket = "youtubecloneapp-bucket"
    key    = "Jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}
