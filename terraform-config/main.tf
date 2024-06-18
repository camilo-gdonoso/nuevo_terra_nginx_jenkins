
# RESOURCES
# Ami
resource "aws_instance" "aws_ubuntu" {
  ami                    = "ami-08a0d1e16fc3f61ea"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.demo_sg_nginx.id]
  #user_data              = file("userdata.tpl")

  tags = {
    Name = "aws_ubuntu"
  }
  provisioner "file" {
    source      = "./index.html"
    destination = "/home/ec2-user/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./key_pair.pem")
      host        = self.public_ip
    }

}
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo chown nginx:nginx /usr/share/nginx/html/index.html",
      "sudo systemctl restart nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./key_pair.pem")
      host        = self.public_ip
    }
  }
}

# Default VPC
resource "aws_default_vpc" "default" {
tags = {
    Name = "Default VPC"
  }
}

# Create a security group
resource "aws_security_group" "demo_sg_nginx" {
  name        = "demo_sg_nginx"
  description = "Security group to allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

