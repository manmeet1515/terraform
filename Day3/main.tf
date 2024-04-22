provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"
}

