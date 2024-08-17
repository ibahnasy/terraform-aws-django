# load_balancer.tf
resource "aws_lb" "pythonapp_lb" {
  name                       = "pythonapp-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web_sg.id]
  subnets                    = aws_subnet.subnet.*.id
  enable_deletion_protection = false
  enable_http2               = true

  depends_on = [aws_lb_target_group.pythonapp_tg]

}

resource "aws_lb_target_group" "pythonapp_tg" {
  name        = "pythonapp-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Load Balancer facing Internet
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.pythonapp_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pythonapp_tg.arn
  }

  depends_on = [aws_lb_target_group.pythonapp_tg]

}
