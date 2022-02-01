resource "aws_instance" "sandbox" {
  #count = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.ami_key_pair_name
  vpc_security_group_ids = [aws_security_group.ingress-all-test.id]
  subnet_id       = aws_subnet.subnet-one.id
  tags            = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
    Name        = var.name
  }
}

/*
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }
}
*/
