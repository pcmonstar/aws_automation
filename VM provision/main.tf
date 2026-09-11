data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "instance" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr == null ? [] : [var.allowed_ssh_cidr]

    content {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  ingress {
    description = "HTTP web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.instance_name}-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.instance.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf install -y httpd
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${var.instance_name}</title>
      </head>
      <body>
        <h1>${var.instance_name} is running</h1>
        <p>Apache was installed and started by Terraform.</p>
      </body>
    </html>
    HTML
    systemctl enable --now httpd
  EOF

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size_gb
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.common_tags, {
    Name = var.instance_name
  })
}