variable "ec2_ami" {
  description = "the value for ec2 ami"
  default = "ami-084568db4383264d4"
}

variable "ec2_instance_type" {
  description = "Value for ec2 instance type"
  default = "t2.micro"
}

variable "env" {
  default = "dev"
}