variable "subnet_id" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter { name = "name" ; values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  associate_public_ip_address = true
  tags = { Name = "jenkins-server" }

  # simple user_data to install docker & java (example)
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y openjdk-11-jdk docker.io
              systemctl enable --now docker
              EOF
}

output "public_ip" { value = aws_instance.jenkins.public_ip }
output "instance_arn" { value = aws_instance.jenkins.arn }
