resource "aws_security_group" "security_group" {
  name        = "${var.instance_name}-sg"
  description = "${var.instance_name}-sg"
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.security_group.id
  description       = "TCP/22 for ALL in Private Range"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "prometheus" {
  security_group_id = aws_security_group.security_group.id
  description       = "TCP/9090 for ALL in Private Range"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 9090
  to_port           = 9090
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.security_group.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
