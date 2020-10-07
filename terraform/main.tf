resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = local.instance_subnet_id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = var.ssh_key_name["dev"]
  vpc_security_group_ids = ["${aws_security_group.security_group.id}"]
  associate_public_ip_address = false

lifecycle {
    ignore_changes       = [subnet_id]
  }

  root_block_device {
      volume_type           = "gp2"
      volume_size           = 20
      encrypted             = false
      delete_on_termination = true
  }

  tags = {
    Name                              = "${var.instance_name}-ec2-instance"
    ManagedBy                         = "terraform"
    PrometheusScrapeEnabled           = "${var.tags["true"]}"
    PrometheusContainerScrapeEnabled  = "${var.tags["false"]}"
  }

  provisioner "local-exec" {
    command = "echo pvt_ip: ${aws_instance.ec2_instance.private_ip} > instance_details.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "echo test connection"
    ]
    connection {
      type                = "ssh"
      user                = var.ssh_user
      host                = self.private_ip
      private_key         = file("${var.ssh_private_key["dev"]}")
      bastion_host        = var.bastion["host"]
      bastion_user        = var.bastion["user"]
      bastion_private_key = file("${var.bastion["private_key"]}")
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "[prometheus]" > inventory.ini
      echo "${aws_instance.ec2_instance.private_ip} ansible_user=${var.ssh_user} ansible_ssh_private_key_file=${var.ssh_private_key["dev"]}" >> inventory.ini
      echo "[prometheus:vars]" >> inventory.ini
      echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh -W %h:%p -q dev-jump-host\"'" >> inventory.ini
      ansible-playbook -u ${var.ssh_user} --private-key ${var.ssh_private_key["dev"]} -i inventory.ini ../ansible/deploy_prometheus.yml
      EOT
  }

}
