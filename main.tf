provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "cidr" {}
variable "security_name" {}
variable "instance_count" {}
variable "ami" {}
variable "instance_type" {}
variable "availability_zone" {}
variable "security_key" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "my_subnet" {
  cidr_block = var.subnet_cidr

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name= "mysubnet"
  }
}

resource "aws_internet_gateway" "mynew_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = {
    Name = "mynewgateway"
  }
}
resource "aws_route_table""mynewroutetable"{
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.mynew_gateway.id
  }
    tags={
      Name = "mynewroutetable"
    }
  }


resource "aws_security_group" "my_new_security_group"{
  name = var.security_name
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.cidr]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [var.cidr]

  }
}

resource "aws_route_table_association""my_new_association"{
  route_table_id = aws_route_table.mynewroutetable.id
  subnet_id = aws_subnet.my_subnet.id

}




resource "aws_instance" "my_instance"{
  count = var.instance_count
  ami = var.ami
  availability_zone = var.availability_zone
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_new_security_group.id]
  key_name = var.security_key
  instance_type = var.instance_type

}

