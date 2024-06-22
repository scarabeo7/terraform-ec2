data "aws_subnets" "subnets" {

      filter {
        name   = "vpc-id"
        values = [data.aws_vpc.selected.id]
      }
    }
resource "aws_lb" "test" {
  name               = "terraform-Web-App-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraform_sg.id]
  subnets            = data.aws_subnets.subnets.ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "test" {
  name     = "terraform-Web-App-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = data.aws_vpc.selected.id
}
resource "aws_lb_target_group" "test1" {
  name     = "terraform-Web-App-tg1"
  port     = 4040
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = data.aws_vpc.selected.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
resource "aws_lb_listener" "front_end1" {
  load_balancer_arn = aws_lb.test.arn
  port              = "4040"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test1.arn
  }
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.instance_asg.id
  lb_target_group_arn    = aws_lb_target_group.test1.arn
}

output "lb_dns" {
  value = "http://${aws_lb.test.dns_name}:4040"
}