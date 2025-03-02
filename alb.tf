resource "aws_lb" "rstudio_alb" {
  name               = "rstudio-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rstudio_sg.id]
  subnets           = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "rstudio-alb"
  }
}

resource "aws_lb_target_group" "rstudio_tg" {
  name     = "rstudio-tg"
  port     = 8787
  protocol = "HTTP"
  vpc_id   = aws_vpc.rstudio_vpc.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.rstudio_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rstudio_tg.arn
  }
}
