provider "aws" {
  region = "us-west-2"
}

# Rede VPC para nossas instâncias
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ci-cd-vpc"
  }
}

# Subnets públicas para EC2
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["us-west-2a", "us-west-2b"], count.index)
}

# Security Group para as instâncias
resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id
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

# Instâncias EC2 para staging e produção
resource "aws_instance" "staging" {
  ami           = "ami-12345678"   # Coloque aqui o ID da AMI desejada
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.allow_all.id]

  tags = {
    Name = "Staging"
  }
}

resource "aws_instance" "production" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[1].id
  security_groups = [aws_security_group.allow_all.id]

  tags = {
    Name = "Production"
  }
}

# Load Balancer para gerenciar Blue/Green Deployment
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "blue_green" {
  name     = "blue-green-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_green.arn
  }
}
