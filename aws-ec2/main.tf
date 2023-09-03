resource "aws_instance" "tf-webserver" {
  ami           = "ami-0700df939e7249d03"
  instance_type = "t3.small"
  tags = {
    Name        = "MyWebserver"
    Description = "Nginx webserver"
  }
  user_data              = <<-EOF
               #!/bin/bash
               sudo yum update -y
               sudo yum install nginx -y
               sudo systemctl start nginx
               sudo systemctl enable nginx 
               EOF
  key_name               = aws_key_pair.web.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
}

resource "aws_key_pair" "web" {
  public_key = file("/home/user1/.ssh/id_rsa.pub")

}
resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "publicIP" {
  value = aws_instance.tf-webserver.public_ip

}
