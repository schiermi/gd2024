terraform {
  backend "s3" {
    bucket = "ebgirlsday-terraform-state"
    key    = "gd2024.tf"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = "Girls Day 2024"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}


variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "dnszone" {
  type = string
}

