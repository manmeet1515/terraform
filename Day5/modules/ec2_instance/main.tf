provider "aws" {
    region = "us-east-1"
}

variable "ami" {
    description = "This is the ami for the isntance"
}

variable "instance_type" {
    description = "This is the isntance type" 
}

resource "aws_instance" "example" {
  ami = var.ami
  instance_type = var.instance_type
}