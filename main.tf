locals {
  ingress_rules = [{
    port             = 80
    description      = "Allowing incoming HTTP traffic"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    },
    {
      port             = 22
      description      = "Allowing incoming SSH traffic from a specific machine"
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip]
      ipv6_cidr_blocks = []
  }]
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "sg-apache-testing-module" {
  name        = "apache-sg"
  description = "Apache Security group"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {

      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
  }

  egress {
    description      = "Allowing all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache-sg"
  }
}

resource "aws_key_pair" "apache_dep_key" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

data "aws_ami" "amazon-linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.yml")
}

resource "aws_instance" "apache-server" {
  ami           = data.aws_ami.amazon-linux2.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.apache_dep_key.key_name
  vpc_security_group_ids = [
    aws_security_group.sg-apache-testing-module.id
  ]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = var.server_name
  }
}
