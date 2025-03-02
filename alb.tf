resource "aws_lb" "existing_rstudio_alb" {
  name               = "rstudio-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.existing_rstudio_sg.id]
  subnets            = [aws_subnet.existing_public_subnet_1.id, aws_subnet.existing_public_subnet_2.id]

  tags = {
    Name = "rstudio-alb"
  }
}

resource "aws_lb_target_group" "existing_rstudio_tg" {
  name     = "rstudio-tg"
  port     = 8787
  protocol = "HTTP"
  vpc_id   = aws_vpc.existing_rstudio_vpc.id
}

resource "aws_lb_listener" "existing_http_listener" {
  load_balancer_arn = aws_lb.existing_rstudio_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.existing_rstudio_tg.arn
  }
}
