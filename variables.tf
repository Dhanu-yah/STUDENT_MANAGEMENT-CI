variable "server_names" {
  default = ["dev-server", "test-server", "prod-server"]
}

resource "aws_instance" "servers" {
  for_each      = toset(var.server_names)
  ami           = "ami-02ec8f3d1073c7e67 (64-bit (x86)) / ami-06152f2391c530fa0 (64-bit (Arm))"
  instance_type = "t3.micro"

  tags = {
    Name = each.key
  }
}
