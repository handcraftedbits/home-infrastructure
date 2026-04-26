resource "aws_instance" "default" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.default.name]
  tags          = var.tags
  user_data     = local.user_data

  root_block_device {
    volume_size = var.disk_space
  }
}

resource "aws_route53_record" "default" {
  name    = var.hostname
  records = [aws_instance.default.public_ip]
  ttl     = 300
  type    = "A"
  zone_id = data.aws_route53_zone.default.id
}

resource "aws_security_group" "default" {
  name = "ec2-${var.hostname}"
  tags = var.tags
}

resource "aws_security_group_rule" "egress" {
  cidr_blocks = ["0.0.0.0/0"]
  description       = "Allow outbound traffic"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.default.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for i, rule in concat([
      {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow inbound SSH"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
      }
    ], var.additional_ingress_rules) : i => rule
  }

  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.default.id
  to_port           = each.value.to_port
  type              = "ingress"
}
