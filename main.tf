data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_servers" {
  count         = 3
  ami           = "ami-02ec8f3d1073c7e67 (64-bit (x86)) / ami-06152f2391c530fa0 (64-bit (Arm))"
  instance_type = "t3.micro"

  tags = {
    Name = "Server-${count.index + 1}"
  }
}
