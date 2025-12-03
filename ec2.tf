# Security Group to allow SSH
resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow SSH inbound traffic and PostgreSQL"
  vpc_id      = ""  # leave blank for default VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allows SSH from anywhere 
  }

   # Allow PostgreSQL (5432) from anywhere 
  ingress {
    from_port   = 5432
    to_port     = 5432
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
# EC2 Instance for Postgres
resource "aws_instance" "postgres_ec2" {
  ami           = "ami-0ecb62995f68bb549"  # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = "test-keypair"           # Your AWS key pair name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.postgres_sg.id]

  user_data = file("${path.module}/user_data/postgres.sh")

  tags = {
    Name = "Postgres-Server"
  }
}
