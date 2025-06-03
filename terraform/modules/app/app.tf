# Security Group do Balanceador de Carga
resource "aws_security_group" "sg-elb" {
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
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
}

# Security Group dos EC2
resource "aws_security_group" "sg-ec2" {
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr]
  }
}

# Load Balancer, Target Group and Listener
resource "aws_lb_target_group" "ec2-lb-tg" {
  name     = "ec2-lb-tg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
}

resource "aws_lb" "ec2-lb" {
  name               = "ec2-lb"
  load_balancer_type = "application"
  subnets            = [var.sn_pub_az1a_id, var.sn_pub_az1c_id]
  security_groups    = [aws_security_group.sg-elb.id]
}

resource "aws_lb_listener" "ec2-lb-listener" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.ec2-lb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-lb-tg.arn
  }
}

# User Data Script for EC2 Instances
data "template_file" "userdata" {
  template = file("./modules/app/scripts/userdata.sh")
}

# Launch Template and Auto Scaling Group for EC2 Instances
resource "aws_launch_template" "ec2-lt" {
  name_prefix            = "app-dynamicsite"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  user_data              = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
}

resource "aws_autoscaling_group" "ec2-asg" {
  name                = "ec2-asg"
  desired_capacity    = var.asg_desired_capacity
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  vpc_zone_identifier = [var.sn_priv_az1a_id, var.sn_priv_az1c_id]
  target_group_arns   = [aws_lb_target_group.ec2-lb-tg.arn]
  launch_template {
    id      = aws_launch_template.ec2-lt.id
    version = "$Latest"
  }
}