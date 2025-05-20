#VPC and security group
resource "aws_default_vpc" "default" {}

resource "aws_security_group" "terra-SG" {
  description = "SG for inbound and outbound traffic from ec2"
  vpc_id = aws_default_vpc.default.id
  tags = {
    Name = "${var.env}-tf"
  }
  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }

  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}

#key pair

resource "aws_key_pair" "my_kp" {
  public_key = file("terraform-key-ec2.pub")
  key_name = "terraform-key-ec2"
}

#ec2 instance

resource "aws_instance" "my_test_instance" {
  ami = var.ec2_ami
  instance_type = var.ec2_instance_type
  tags = {
    Name = "${var.env}-tf"
  }
  user_data = file("nginx.sh")
  key_name = aws_key_pair.my_kp.key_name
  security_groups = [ aws_security_group.terra-SG.name ]
}

