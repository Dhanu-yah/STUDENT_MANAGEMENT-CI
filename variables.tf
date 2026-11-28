variable "server_names" {
  default = ["dev-server", "test-server", "prod-server"]
}

resource "aws_instance" "servers" {
  for_each      = toset(var.server_names)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = each.key
  }
}
