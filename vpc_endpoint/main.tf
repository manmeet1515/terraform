#VPC 

resource "aws_vpc" "vpc_to_test_VPCEndpoint" {
  tags = {
    Name = "${var.env}-VPC"
  }
}

#private subnet

#Route table for private subnet

#route table-privatesubnet association

#EC2 instance running in that private subnet.

#S3 bucket

#IAM role attached to the EC2 instance with permission to access S3.

#Gateway Endpoint for S3

#Attach IAM Role to EC2 Instance

