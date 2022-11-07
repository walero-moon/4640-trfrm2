variable "do_token" {}

# Set default region
variable "region" {
  type = string
  default = "sfo3"
}

variable "droplet_count" {
  type = number
  default = 2
}