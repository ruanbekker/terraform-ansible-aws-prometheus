variable "project" {
    default = "prometheus-a-dev"
}

variable "region" {
    default = "eu-west-1"
}

variable "instance_name" {
    default = "prometheus-a-dev"
}

variable "instance_type" {
    default = "t2.small"
}

variable "ssh_user" {
    default = "ubuntu"
}

variable "ssh_private_key" {
    type = map(string)
    default = {
        prod = "~/.ssh/aws_prod.pem"
        dev  = "~/.ssh/aws_dev.pem"
    }
}

variable "ssh_key_name" {
    type = map(string)
    default = {
        prod = "aws_prod"
        dev  = "aws_dev"
    }
}

variable "tags" {
    type = map(string)
    default = {
        name          = "prometheus-a-dev"
        true          = "Enabled"
        false         = "Disabled"
    }
}

variable "bastion" {
    type = map(string)
    default = {
        host        = "eu-dev-jumphost.mydomain.com"
        user        = "ubuntu"
        private_key = "~/.ssh/id_rsa"
    }
}
