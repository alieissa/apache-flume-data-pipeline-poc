variable "type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-0039da1f3917fa8e3"
}

variable "public_network_interface_id" {
  type = string
}

variable "private_network_interface_id" {
  type = string
}