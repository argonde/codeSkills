terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.1.0"
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "JED"
}

locals {
  today_date = formatdate("YYYY-MM-DD", timestamp())
}

data "aws_availability_zones" "available" {
  state = "available"
}

# create the vpc
resource "aws_vpc" "sn_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.vpc_tags
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.sn_vpc.id # vpc_id will be generated after we create VPC
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count      = length(var.vpc_public_subnets)
  vpc_id     = aws_vpc.sn_vpc.id
  cidr_block = element(var.vpc_public_subnets, count.index) # CIDR block of the public subnets
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count      = length(var.vpc_private_subnets)
  vpc_id     = aws_vpc.sn_vpc.id
  cidr_block = element(var.vpc_private_subnets, count.index) # CIDR block of the private subnets
}

# Route Table for Public Subnets
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.sn_vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public SN to www via IGateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}
# Route Table for Private Subnets
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.sn_vpc.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private SN to www via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
}

# Route Table Association with Public Subnets
resource "aws_route_table_association" "PubRT_association" {
  count          = var.asg-web_instance_count
  route_table_id = aws_route_table.PublicRT.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

# Route Table Association with Private Subnets
resource "aws_route_table_association" "PrivRT_association" {
  count          = var.asg-prv1_instance_count
  route_table_id = aws_route_table.PrivateRT.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

# Provide an elastic IP to the gateway
resource "aws_eip" "nateIP" {
  vpc = true
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.public_subnets[0].id
}

# select a specific base instance image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# customise the instance image to become an apache webserver
resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = aws_subnet.public_subnets[0].id
  instance_type          = var.aws_type
  vpc_security_group_ids = [aws_security_group.sg_8080.id]
  user_data              = <<-EOF
               #!/bin/bash
               echo "Hello Peytz" > index.html
               nohup busybox httpd -f -p 8080 &
               EOF
  tags = {
    Name = "tf-ubuntu-learn-ec2"
  }
}

# create a security group for the vpc
resource "aws_security_group" "sg_8080" {
  vpc_id = aws_vpc.sn_vpc.id
  name   = "tf-ubuntu-learn-sg"
  ingress {
    from_port   = var.server_ports
    to_port     = var.server_ports
    protocol    = var.server_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create a new image from the custom web server instances
resource "aws_ami_from_instance" "webserver-ami" {
  name               = "webserver-ami"
  source_instance_id = aws_instance.webserver.id
}

# create a launch template for the asg in the private subnet
resource "aws_launch_template" "rdir-all-doms-ltp" {
  name                                 = "private-sn-ltp"
  image_id                             = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.aws_type
  update_default_version               = true

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  disable_api_termination = true
  ebs_optimized           = true

  monitoring {
    enabled = false
  }

  placement {
    availability_zone = data.aws_availability_zones.available.names[0]
  }

  vpc_security_group_ids = [aws_security_group.sg_8080.id]

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "rdir-all-doms-ltp"
    }
  }
}

# create an autoscaling group to manage HA of private instances
resource "aws_autoscaling_group" "asg-prv1" {
  name                      = "redirect_all_domains"
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  wait_for_capacity_timeout = 0
  vpc_zone_identifier       = ["split(", ",var.vpc_private_subnets)"]

  launch_template {
    id      = aws_launch_template.rdir-all-doms-ltp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-state_1"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Refresh deployment without an outage.
  lifecycle {
    create_before_destroy = true
  }
}

# scale out - stage 1: spin new instances based on the updated ltp
resource "aws_autoscaling_schedule" "scale_out" {
  scheduled_action_name  = "st1-scale-out"
  min_size               = 4
  max_size               = 4
  desired_capacity       = 4
  start_time             = "${local.today_date}T21:29:00Z"
  autoscaling_group_name = aws_autoscaling_group.asg-prv1.name
}

# scale in - stage 2: terminate old outdated instances
resource "aws_autoscaling_schedule" "scale_in" {
  scheduled_action_name  = "st2-scale-in"
  min_size               = 2
  max_size               = 2
  desired_capacity       = 2
  start_time             = "${local.today_date}T21:59:00Z"
  autoscaling_group_name = aws_autoscaling_group.asg-prv1.name
}

# create a launch template for the asg in the public subnet
resource "aws_launch_template" "web-servers-ltp" {
  name                                 = "public-sn-ltp"
  image_id                             = aws_ami_from_instance.webserver-ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.aws_type
  update_default_version               = true

  block_device_mappings {
    device_name = "/dev/sda2"
    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 8
      volume_type           = "gp2"
    }
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  disable_api_termination = true
  ebs_optimized           = true

  monitoring {
    enabled = false
  }

  placement {
    availability_zone = data.aws_availability_zones.available.names[0]
  }

  vpc_security_group_ids = [aws_security_group.sg_8080.id]

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver-ltp"
    }
  }
}

# create an autoscaling group to manage HA of public servers
resource "aws_autoscaling_group" "asg-web" {
  name                      = "webservers-asg"
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 300
  termination_policies      = ["OldestInstance"]
  wait_for_capacity_timeout = 0
  vpc_zone_identifier       = ["split(", ",var.vpc_public_subnets)"]

  launch_template {
    id      = aws_launch_template.web-servers-ltp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-web"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Refresh deployment without an outage.
  lifecycle {
    create_before_destroy = true
  }
}

# create a security group for the load balancer
resource "aws_security_group" "elb-sg" {
  name = "terraform-sample-elb-sg"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "sample" {
  name                = "terraform-asg-sample"
  security_groups     = [aws_security_group.elb-sg.id]
  availability_zones  = data.aws_availability_zones.available.names

  health_check {
    target              = "HTTP:${var.server_ports}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Adding a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_ports
    instance_protocol = "http"
  }
}