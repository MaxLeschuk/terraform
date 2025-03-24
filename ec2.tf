resource "aws_instance" "ubuntu" {
  ami             = "ami-0c1ac8a41498c1a9c"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ubuntu_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              echo "Hello World from $(lsb_release -d | cut -f2)" > /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx

              # Docker Installation (Official Guide)
              apt install -y ca-certificates curl gnupg
              install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
              chmod a+r /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt update -y
              apt install -y docker-ce docker-ce-cli containerd.io
              systemctl enable docker
              systemctl start docker
              EOF
  tags = {
    Name = "Ubuntu-Web-Server"
  }
}

resource "aws_instance" "amazon_linux" {
  ami             = "ami-0c2e61fdcb5495691"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.amazon_sg.id]

  tags = {
    Name = "Amazon-Private-Instance"
  }
}