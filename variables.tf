variable "vpc_id" {
  type = string
}

variable "public_key" {
  type = string
}

variable "server_name" {
  type    = string
  default = "terraform-apache-server"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "my_ip" {
  type        = string
  description = "My ip address with cidr for example: 3.83.146.108/32"
}
