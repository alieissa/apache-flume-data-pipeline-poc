terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  profile = "default"
}

module "network" {
  source = "./network"
}

module "instance" {
  source = "./instance"
  network_interface = {
    private = module.network.network_interface.private
    public  = module.network.network_interface.public
  }
}

module "lambda" {
  source = "./lambda"

  function = {
    name    = "sendS3EventToIngestor"
    path    = "./send-s3-event-to-ingestor.js"
    handler = "sendS3EventToIngestor"
  }

  // TODO Get info from S3
  bucket = {
    name = "flume-ng-dev"
    arn  = "arn:aws:s3:::flume-ng-dev"
  }
}