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