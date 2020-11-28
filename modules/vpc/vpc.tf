## vpc.tf
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  tags = {
    Name = "${var.env}_vpc"
    Env  = var.env
  }
}
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet
  map_public_ip_on_launch = "true"
tags = {
    Name = "${var.env}_subnet"
    Env  = var.env
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
tags = {
    Name = "${var.env}_gw"
    Env  = var.env
  }
}
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
tags = {
    Name = "default route table"
    env  = var.env
  }
}
resource "aws_instance" "Ec2" {
  ami                    = "ami-08f63db601b82ff5f" #id of desired AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.ec2.id] # list
  tags = {
    Name = "TerraformDemo"
  }

}
