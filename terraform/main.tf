terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    encrypt        = true
    bucket         = "mothersect-tf-state"
    dynamodb_table = "mothersect-tf-state-lock"
    key            = "story-teller"
    region         = "us-east-1"
  }
}
