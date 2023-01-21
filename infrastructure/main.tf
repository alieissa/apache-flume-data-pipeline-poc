terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
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
  private_network_interface_id = module.network.private_network_interface_id
  public_network_interface_id = module.network.public_network_interface_id
}