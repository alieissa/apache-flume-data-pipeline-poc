variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}



variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

# 10.0.0.1, 10.0.0.2, 10.0.0.3 and 10.0.0.255 are reserved by AWS
# https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html
variable "instance_ip" {
  type    = string
  default = "10.0.0.5"
}