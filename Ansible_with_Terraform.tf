provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"]
}

variable "public_key" {
  description = "Path to the SSH public key"
  type        = string
  default     = "/home/ubuntu/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2"
  public_key = file(var.public_key)
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true
  subnet_id                   = "subnet-0d0ed4318de0cf810"
  tags = {
    Name = "target-meshy",
    Tag = "created by CLI"
  }
}

resource "local_file" "host_ip" {
  filename = "host_ip_list.txt"
  content  = aws_instance.this.public_ip
}

output "aws_instance_ip" {
  value = aws_instance.this.public_ip
}
