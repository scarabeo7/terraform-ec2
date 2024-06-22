resource "aws_launch_template" "instance_template" {
  name          = "instance-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/init.sh")
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform-Web-App"
    }
  }
}

resource "aws_autoscaling_group" "instance_asg" {
  name = "terraform-Web-App-ASG"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  # vpc_zone_identifier       = [data.aws_subnet.selected1.id, data.aws_subnet.selected2.id]
  wait_for_capacity_timeout = 0
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  launch_template {
    id      = aws_launch_template.instance_template.id
    version = aws_launch_template.instance_template.latest_version
  }
}

resource "aws_security_group" "terraform_sg" {

  vpc_id = data.aws_vpc.selected.id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    description      = "HTTP from VPC"
    from_port        = 4040
    to_port          = 4040
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "HTTP from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform sg"
  }

}
