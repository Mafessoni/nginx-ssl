terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "otavio@xpert.com.br"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-01"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-01"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-01"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "route-table-01"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_key_pair" "deployer" {
  key_name   = "otavio-not"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaxgodFpqRhMWGjoR3LcNNF7ZzGNuZ27XSOIoxU+j8ttd4wkLb02Ex6wTsyzd5oBRH/TIDFQdhtcwso68/8ASOQnwCJQcomKAzue2EAay0NhLZ0dws6cwJWIDS6odm7qoInU48Vr28wCd/0GOApMok+GfBJzPVgqgPB7kBGEW+QTNOSTpisX2pzgRZuHsvLnvk7tjcS4LQLs5KnomPNsGu8vgECuyN4dgrhFuMrNxM9f7ua+Lh/7QVV6lQajE8OLcTWT5DLneGnOtHD7m4GAuejeSToMIdUVxlQVR5GqVgD/pGiFwLRSbk90Rst2KCfBJJ+M4x0jxHSqj3EjIl86UUqVjIQoM26S7xut2sftKT6fu47Z7HeHcSuC5ydY1FBnnV/Ezu509YWcizYJIhQ7UpM4tf9oNsl1lcsxaZpcL/y3ge4xqbw7EpgKpsOr3TT4lULGBKQbF1q9Gdyj0Dv6SGLWZJARmfMnSLxJNv7XQDrDXd872zT+BS9ydVmDtAlyE= otavio@otavio-not"
  #Pegar a chave publica da tua maquina
}

resource "aws_instance" "web" {
  ami                         = "ami-0e86e20dae9224db8"
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.security_group.id]

  tags = {
    Name = "ec2-01"
  }
}

resource "aws_security_group" "security_group" {
  name        = "GS_ec2-01"
  description = "Grupo de Seguranca - Liberando"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Liberacao da porta 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "Liberacao da porta 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Liberacao da porta 443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Liberacao da porta 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "GS_ec2-01"
  }
}
output "ip-ec2" {
  value = aws_instance.web.public_ip
}
