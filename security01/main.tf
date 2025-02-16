provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  tags = {
    Name = "MyMachine"
  }
}