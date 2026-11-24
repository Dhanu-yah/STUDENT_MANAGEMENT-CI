provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_servers" {
  count         = 3
  ami           = "ami-0aba19e56f3eaec05"
  instance_type = "t3.micro"

  tags = {
    Name = "Server-${count.index + 1}"
  }
}
