provider "aws" {
  region = var.aws_region
}

# Generate a new SSH key pair locally
resource "tls_private_key" "environment_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Upload the public key to AWS
resource "aws_key_pair" "environment_key" {
  key_name   = "${var.environment}_key_pair"
  public_key = tls_private_key.environment_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "private_key" {
  filename        = "${path.module}/${var.environment}_key.pem"
  content         = tls_private_key.environment_key.private_key_pem
  file_permission = "0600"
}

# Security group for the environment
resource "aws_security_group" "environment_sg" {
  name_prefix = "${var.environment}_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open SSH for all; adjust as necessary
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-sg"
  }
}

# EC2 instance for the environment
resource "aws_instance" "environment_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.environment_key.key_name
  security_groups = [aws_security_group.environment_sg.name]

  root_block_device {
    volume_size = local.storage_size
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.environment}-instance"
  }
}
