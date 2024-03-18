resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-Security Group"
  vpc_id      = "vpc-07ffaafdeb3ae3740"
  description = "Open 22,443,80,8080,9000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-07d9b9ddc6cd8dd30"
  instance_type               = "t2.large"
  key_name                    = "My-Nova-kp"
  vpc_security_group_ids      = [aws_security_group.Jenkins-sg.id]
  user_data                   = templatefile("./install_jenkins.sh", {})
  associate_public_ip_address = true
  subnet_id                   = "subnet-00c4c233b6d4b4a67"


  tags = {
    Name = "Jenkins-Server"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "web2" {
  ami                         = "ami-07d9b9ddc6cd8dd30"
  instance_type               = "t2.medium"
  key_name                    = "My-Nova-kp"
  vpc_security_group_ids      = [aws_security_group.Jenkins-sg.id]
  associate_public_ip_address = true
  subnet_id                   = "subnet-00c4c233b6d4b4a67"


  tags = {
    Name = "Splunk-Server"
  }

  root_block_device {
    volume_size = 30
  }
}