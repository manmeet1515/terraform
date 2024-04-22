provider "aws" {
    region = "us-east-1"
}
variable "cidr" {
  default = "10.10.10.0/24"
}

resource "aws_key_pair" "example" {
  key_name = "my_kp"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.10.10.0/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "route" {
  route_table_id = aws_route_table.my_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "my_rta" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "web_sg" {
  name = "allow web traffic"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "server" {
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example.key_name
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [ aws_security_group.web_sg.id ]


  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }
  
provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
}

provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]

}
}