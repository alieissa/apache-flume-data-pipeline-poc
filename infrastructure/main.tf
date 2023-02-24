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
  region              = var.region
  shared_config_files = [var.credentials_path]
  profile             = "default"
}

module "network" {
  source = "./network"
}

module "instance" {
  source            = "./instance"
  network_interface = module.network.network_interface
}

module "lambda" {
  source = "./lambda"

  function = {
    name    = "sendS3EventToIngestor"
    path    = "./s3-event.js"
    handler = "s3-event.handler"
  }

  // TODO Get info from S3
  bucket = {
    name = "flume-ng-dev"
    arn  = "arn:aws:s3:::flume-ng-dev"
  }

  vpc_config = {
    subnet_ids = [ module.network.subnet_id ]
    security_group_ids = [ module.network.security_group_id ]
  }
}