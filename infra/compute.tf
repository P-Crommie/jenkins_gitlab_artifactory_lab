#Jenkins Server
resource "aws_instance" "cicd_lab" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_type
  iam_instance_profile = aws_iam_instance_profile.this.name
  key_name               = var.key_name
  subnet_id              = aws_subnet.public.id
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.lab_ports.id, aws_security_group.allow_ssh.id, aws_security_group.go_outside.id, aws_security_group.http.id]
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
  }
  associate_public_ip_address = "true"

  tags = {
    Name = "${var.project}"
  }
  user_data = file("${path.module}/userdata/config.sh")
}


# Generate the SSH keypair that we’ll use to configure the EC2 instance.
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename        = "${var.user_home_directory}/.ssh/${var.key_name}.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}
