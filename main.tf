provider "aws" {
    profile = "aws_provider"
    region  = var.my_region
    access_key = var.my_access_key
    secret_key = var.my_secret_key
}
resource "aws_vpc" "SRE_vpc" {
   cidr_block = "10.10.0.0/16"
   enable_dns_hostnames = "true"
   tags =  { Name = "SRE_vpc"}
}
resource "aws_internet_gateway" "SRE_igw" {
    vpc_id = aws_vpc.SRE_vpc.id
    tags = { Name = "SRE_igw"}
}
resource "aws_subnet" "SRE_public1" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block = "10.10.11.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = true
    tags = { Name = "SRE_public1"}
}
resource "aws_subnet" "SRE_public2" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block  = "10.10.12.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = true
    tags = { Name = "SRE_public2"}
}
resource "aws_subnet" "SRE_private1" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block = "10.10.13.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = { Name = "SRE_private1"}
}
resource "aws_subnet" "SRE_private2" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block  = "10.10.14.0/24"
    availability_zone = "ap-northeast-2c"
    tags = { Name = "SRE_private2"}
}
resource "aws_subnet" "SRE_private3" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block = "10.10.15.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = { Name = "SRE_private3"}
}
resource "aws_subnet" "SRE_private4" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block  = "10.10.16.0/24"
    availability_zone = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = { Name = "SRE_private4"}
}
resource "aws_subnet" "SRE_db1" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block = "10.10.17.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = { Name = "SRE_db1"}
}
resource "aws_subnet" "SRE_db2" {
    vpc_id = aws_vpc.SRE_vpc.id
    cidr_block  = "10.10.18.0/24"
    availability_zone = "ap-northeast-2c"
    tags = { Name = "SRE_db2"}
}
resource "aws_eip" "SRE_nat_ip" {
   vpc = true
   depends_on  = [aws_internet_gateway.SRE_igw]
   tags = { Name = "SRE_nat_ip"}
}
resource "aws_nat_gateway" "SRE_natgw" {
  allocation_id = aws_eip.SRE_nat_ip.id
  subnet_id     = aws_subnet.SRE_public1.id
  tags = { Name = "SRE_natgw"}
}
resource "aws_route_table" "SRE_public" {
  vpc_id = aws_vpc.SRE_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.SRE_igw.id
 }
  tags = { Name = "SRE_public" }
}
resource "aws_route_table" "SRE_private" {
  vpc_id = aws_vpc.SRE_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.SRE_natgw.id
  }
  tags = { Name = "SRE_private" }
}
resource "aws_route_table_association" "SRE_public1" {
  subnet_id      = aws_subnet.SRE_public1.id
  route_table_id = aws_route_table.SRE_public.id
}
resource "aws_route_table_association" "SRE_public2" {
  subnet_id      = aws_subnet.SRE_public2.id
  route_table_id = aws_route_table.SRE_public.id
}
resource "aws_route_table_association" "SRE_private1" {
  subnet_id      = aws_subnet.SRE_private1.id
  route_table_id = aws_route_table.SRE_private.id
}
resource "aws_route_table_association" "SRE_private2" {
  subnet_id      = aws_subnet.SRE_private2.id
  route_table_id = aws_route_table.SRE_private.id
}
resource "aws_route_table_association" "SRE_private3" {
  subnet_id      = aws_subnet.SRE_private3.id
  route_table_id = aws_route_table.SRE_private.id
}
resource "aws_route_table_association" "SRE_private4" {
  subnet_id      = aws_subnet.SRE_private4.id
  route_table_id = aws_route_table.SRE_private.id
}
resource "aws_route_table_association" "SRE_db1" {
    subnet_id       = aws_subnet.SRE_db1.id
    route_table_id  = aws_route_table.SRE_private.id
}
resource "aws_route_table_association" "SRE_db2" {
    subnet_id       = aws_subnet.SRE_db2.id
    route_table_id  = aws_route_table.SRE_private.id
}
resource "aws_security_group" "SRE_sg1" {
    name        = "SRE_sg1"
    vpc_id      = aws_vpc.SRE_vpc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
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
resource "aws_security_group" "SRE_sg2" {
    name        = "SRE_sg2"
    vpc_id      = aws_vpc.SRE_vpc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.10.11.0/24"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "SRE_sg3" {
    name        = "SRE_sg3"
    vpc_id      = aws_vpc.SRE_vpc.id
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.10.11.0/24"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "SRE_sg_db" {
    name        = "SRE_sg_db"
    vpc_id      = aws_vpc.SRE_vpc.id
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.10.0.0/16"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "SRE_bastion" {
    instance_type           = "t2.micro"
    ami                     = var.image_id_web
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.SRE_sg1.id]
    subnet_id               = aws_subnet.SRE_public1.id
    associate_public_ip_address = true
    tags = {Name = "SRE_bastion"}
}
resource "aws_instance" "SRE_web1" {
    instance_type           = "t2.micro"
    ami                     = var.image_id_web
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.SRE_sg2.id]
    subnet_id               = aws_subnet.SRE_private1.id
    associate_public_ip_address = false
    tags = { Name = "SRE_web1"}
}
resource "aws_instance" "SRE_web2" {
    instance_type           = "t2.micro"
    ami                     = var.image_id_web
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.SRE_sg2.id]
    subnet_id               = aws_subnet.SRE_private2.id
    associate_public_ip_address = false
    tags = { Name = "SRE_web2"  }
}
resource "aws_instance" "SRE_was1" {
    instance_type           = "t2.micro"
    ami                     = var.image_id_was
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.SRE_sg3.id]
    subnet_id               = aws_subnet.SRE_private3.id
    associate_public_ip_address = false
    tags = {  Name = "SRE_was1"  }
}
resource "aws_instance" "SRE_was2" {
    instance_type           = "t2.micro"
    ami                     = var.image_id_was
    key_name                = var.key_name
    vpc_security_group_ids  = [aws_security_group.SRE_sg3.id]
    subnet_id               = aws_subnet.SRE_private4.id
    associate_public_ip_address = false
    tags = { Name = "SRE_was2"}
}
resource "aws_alb_target_group" "SRE_web" {
  name     = "SRE-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.SRE_vpc.id
 health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 30
    port                = 80
  }
  tags = {Name   = "SRE_web" }
}
resource "aws_alb_target_group" "SRE_was" {
  name     = "SRE-was"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.SRE_vpc.id
 health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 30
    port                = 8080
  }
  tags = {Name  = "SRE_was"}
}
resource "aws_alb_target_group_attachment" "SRE_web1" {
  target_group_arn = aws_alb_target_group.SRE_web.arn
  target_id        = aws_instance.SRE_web1.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "SRE_web2" {
  target_group_arn = aws_alb_target_group.SRE_web.arn
  target_id        = aws_instance.SRE_web2.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "SRE_was1" {
  target_group_arn = aws_alb_target_group.SRE_was.arn
  target_id        = aws_instance.SRE_was1.id
  port             = 8080
}
resource "aws_alb_target_group_attachment" "SRE_was2" {
  target_group_arn = aws_alb_target_group.SRE_was.arn
  target_id        = aws_instance.SRE_was2.id
  port             = 8080
}
resource "aws_elb" "SRE_external" {
    name     = "SRE-external"
    subnets         = [aws_subnet.SRE_public1.id, aws_subnet.SRE_public2.id]
    security_groups = [aws_security_group.SRE_sg1.id]
    instances       = [aws_instance.SRE_web1.id, aws_instance.SRE_web2.id]
    listener {
        instance_port       = 80
        instance_protocol   = "http"
        lb_port             = 80
        lb_protocol         = "http"
    }
}
resource "aws_elb" "SRE_internal" {
    name            = "SRE-internal"
    subnets         = [aws_subnet.SRE_private3.id, aws_subnet.SRE_private4.id]
    security_groups = [aws_security_group.SRE_sg1.id]
    instances       = [aws_instance.SRE_was1.id, aws_instance.SRE_was2.id]
    listener {
        instance_port       = 8080
        instance_protocol   = "http"
        lb_port             = 8080
        lb_protocol         = "http"
    }
}
resource "aws_db_subnet_group" "SRE_db_sg" {
    name = "sre-db-sg"
    subnet_ids = [aws_subnet.SRE_db1.id, aws_subnet.SRE_db2.id]
}
resource "aws_db_instance" "SRE_db" {
    allocated_storage   = 20
    engine              = "mysql"
    engine_version      = "5.7.26"
    instance_class      = "db.t2.micro"
    username            = var.db_username
    password            = var.db_password
    port                = var.db_port
    db_subnet_group_name = aws_db_subnet_group.SRE_db_sg.name
    skip_final_snapshot = true
    multi_az		= true
}
