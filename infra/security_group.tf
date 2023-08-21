resource "aws_security_group" "lab_ports" {
  name   = "${var.project}-lab_ports"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 8020
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }
  tags = {
    Name = "${var.project}-lab_ports"
  }
}

resource "aws_security_group" "http" {
  name   = "${var.project}-http"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }
  tags = {
    Name = "${var.project}-http"
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "${var.project}-allow_ssh"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidr_blocks
  }
  tags = {
    Name = "${var.project}-allow_ssh"
  }
}

resource "aws_security_group" "go_outside" {
  name   = "${var.project}-go_outside"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-go_outside"
  }
}