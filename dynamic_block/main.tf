#Configure the AWS provider
provider "aws" {
  # Replace with your actual AWS credentials
  access_key = "YOUR_ACCESS_KEY"
  secret_key = "YOUR_SECRET_KEY"
  region     = "us-east-1" # Replace with your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

locals {
  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


resource "aws_security_group" "dynamic_sg" {
  name   = "dynamic-sg"
  vpc_id = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  #ingress {
  #  from_port = 22
  #  to_port = 22
  #  protocol = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  #ingress {
  #  from_port = 80
  #  to_port = 80
  #  protocol = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}
}

locals {
  instance_suffix = "001"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id # Ensures subnet is within the created VPC
  cidr_block        = "10.0.1.0/24"     # Specify a valid CIDR block within the VPC's range
  availability_zone = "us-east-1a"      # Adjust to your desired AZ

  tags = {
    Name = "MySubnet"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e1bed4f06a3b463d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "WebServer-${local.instance_suffix}"
  }
}


# To showcase data block
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}

output "ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}
