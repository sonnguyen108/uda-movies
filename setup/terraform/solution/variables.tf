variable "location" {
  type = string
  default = "us-east-1"
}
variable "public_az" {
  type = string
  default = "us-east-1a"
}
variable "k8s_version" {
  default = "1.25"
}

variable "enable_private" {
  default = false
}
variable "private_az" {
  type        = string
  description = "Change this to a letter a-f only if you encounter an error during setup"
  default     = "us-east-1b"
}
