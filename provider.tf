terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "acntfdemo"
    key    = "terraform/acntfdemo.tfstate"
    region = "ap-southeast-1"
  }
}
