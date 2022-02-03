terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = "0.14.7"
}

provider "aws" {
  region                  = "eu-north-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "win"
}

locals {
  today_date = formatdate("YYYY-MM-DD", timestamp())
}

# get the updated instance identity by picking up first its private IP from the directory
data "aws_instance" "ip" {
  filter {
    name   = "network-interface.addresses.private-ip-address"
    values = [file("./ip_artifact.txt")]
  }
}

# the use a bash script to get from AWS CLI the instance ID: query to match instance ID and private_IP
data "external" "get_instance_id_using_shell" {
  program = ["bash","./getPrivate_IP.sh"]
  query = {
    ip = data.aws_instance.ip
  }
}

# create a new image from an instance
resource "aws_ami_from_instance" "redirect-all-domains" {
  name               = "SN-redirect-all-domains"
  # use the instance ID that resulted from the previous query
  source_instance_id = data.external.get_instance_id_using_shell.result.instance_id
}

# import existing infrastructure
resource "aws_launch_template" "ltp" {
  image_id               = aws_ami_from_instance.redirect-all-domains.source_instance_id
  update_default_version = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  max_size = 4
  min_size = 4

  launch_template {
    id      = aws_launch_template.ltp.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # refresh deployment without an outage: it prevents Terraform from failing when LC is updated and attached to ASG
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
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# scale in - stage 2: terminate old outdated instances
resource "aws_autoscaling_schedule" "scale_in" {
  scheduled_action_name  = "st2-scale-in"
  min_size               = 2
  max_size               = 2
  desired_capacity       = 2
  start_time             = "${local.today_date}T21:59:00Z"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
