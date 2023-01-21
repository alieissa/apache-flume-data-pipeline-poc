variable "type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = "ami-0039da1f3917fa8e3"
}

variable "network_interface" {
  type = object({
    private = string
    public  = string
  })
}