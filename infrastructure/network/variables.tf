variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "private_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_cidr" {
  type = string
  default = "10.0.2.0/24"
}