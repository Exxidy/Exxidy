locals {
  vpc_id           = "vpc-0cd9cb335b8e59d04"
  subnet_id        = "subnet-09687736049cae678"
  ssh_user         = "ubuntu"
  key_name         = "admin_exd"
  private_key_path = "/Users/edgarlubitelev/Desktop/git_main/admin_exd.pem"
}
# ansible-playbook  -i 13.60.52.219, --private-key /Users/edgarlubitelev/Desktop/git_main/admin_exd.pem 000_setup.yaml
provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "ec2-instal-3-v-1" {
  name        = "Jenkins Security Group"
  description = "CI_CD SecurityGroup"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "3-v-1"
    Owner = "Edgar"
  }
}

resource "aws_instance" "ec2-apache-jenkins" {
  ami                         = "ami-0914547665e6a707c"
  subnet_id                   = "subnet-09687736049cae678"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2-instal-3-v-1.id]
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ec2-apache-jenkins.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ec2-apache-jenkins.public_ip}, --private-key ${local.private_key_path} 000_setup.yaml"
  }
}

resource "aws_instance" "ec2-apache-wildfly" {
  ami                         = "ami-0914547665e6a707c"
  subnet_id                   = "subnet-09687736049cae678"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2-instal-3-v-1.id]
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ec2-apache-wildfly.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ec2-apache-wildfly.public_ip}, --private-key ${local.private_key_path} 010_setup.yaml"
  }
}

resource "aws_instance" "ec2-jdk" {
  ami                         = "ami-0914547665e6a707c"
  subnet_id                   = "subnet-09687736049cae678"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2-instal-3-v-1.id]
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ec2-jdk.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ec2-jdk.public_ip}, --private-key ${local.private_key_path} 020_setup.yaml"
  }
}

output "ec2-apache-jenkins" {
  value = aws_instance.ec2-apache-jenkins.public_ip
}

output "ec2-apache-wildfly" {
  value = aws_instance.ec2-apache-wildfly.public_ip
}

output "ec2-jdk" {
  value = aws_instance.ec2-jdk.public_ip
}
