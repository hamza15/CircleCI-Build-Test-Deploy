provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "main" {
    route_table_id = aws_route_table.main.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public"
  }

  depends_on = [aws_internet_gateway.gw]
}


resource "aws_security_group" "sg-infra" {
  name          = "custom-sg"
  description   = "Allow HTTP, SSH and internal"
  vpc_id        = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "Custom-SG"
  }
}

resource "aws_eip" "eip" {
  vpc                       = true
  instance                  = aws_instance.VM.id
  associate_with_private_ip = "10.0.1.12"
  depends_on                = [aws_internet_gateway.gw]
}


resource "aws_instance" "VM" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet-1.id
  private_ip    = "10.0.1.12"
  vpc_security_group_ids = [aws_security_group.sg-infra.id]
  key_name      = "Docker"
  user_data = <<-EOF
      #! /bin/bash
      apt-get update
      apt-get install ruby
      apt-get install wget
      cd /home/ubuntu
      wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
      chmod +x ./install
      ./install auto
      service codedeploy-agent start
      apt-get install python3-pip -y
      pip3 install Flask
      mkdir /home/ubuntu/app
      EOF
  tags = {
    Name = "Test"
  }

  depends_on   = [aws_security_group.sg-infra]
}
