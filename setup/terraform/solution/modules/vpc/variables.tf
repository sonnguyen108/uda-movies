variable "public_az" {
  type = string
  default = "us-east-1a"
}
variable "private_az" {
  type        = string
  description = "Change this to a letter a-f only if you encounter an error during setup"
  default     = "us-east-1b"
}
