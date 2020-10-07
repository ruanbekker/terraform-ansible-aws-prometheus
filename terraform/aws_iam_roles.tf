resource "aws_iam_role" "iam_role" {
  name               = "${var.instance_name}-terraform-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_policy_attachment" "iam_role_policy_attach" {
  name               = "${var.instance_name}-policy-attachment"
  roles              = ["${aws_iam_role.iam_role.name}"]
  policy_arn         = data.aws_iam_policy.AmazonEC2ReadOnlyAccess.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name               = "${var.instance_name}-instance-profile"
  role               = aws_iam_role.iam_role.name
}
