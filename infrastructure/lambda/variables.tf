variable "function" {
  type = object({
    name    = string
    path    = string
    handler = string
  })
}

variable "bucket" {
  type = object({
    name = string
    arn  = string
  })
}

variable "vpc_config" {
  type = object({
    subnet_ids = list(string)
    security_group_ids = list(string)
    })
}