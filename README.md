# terraform-ansible-aws-prometheus
Setup Prometheus with Thanos Sidecar on AWS using Terraform and Ansible

## Pre-Requirements

1. I am spinning up a EC2 instance in a Private Subnet and only reachable via a bastion host, that is called `dev-jump-host`, which I've setup in my `~/.ssh/config` as:

```
Host *
    Port 22
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30
    
Host dev-jump-host
    HostName eu-dev-jumphost.mydomain.com
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
```

2. My default VPC is tagged: `Key:default, Value:true`, and that is how I get the VPC id.

3. My private subnets are tagged: `Key:Tier, Value:private`, and that is how I retrieve the subnet id's and using the random function to select a random subnet id from the 3 every time I deploy.

4. I still have a couple of hard coded values in `variables.tf`, `bucket.yml`, the hostnames in `prometheus.yml`, etc.

## Usage

Install ansible:

```
$ virtualenv -p python3 .venv
$ source .venv/bin/activate
$ pip install -r requirements.txt
```

Install terraform:

```
$ wget https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip
$ unzip terraform_0.13.3_linux_amd64.zip
$ sudo mv terraform /usr/local/bin/terraform
```

Update the variables, configs and hardcoded values, then initialize, and apply:

```
$ terraform init
$ terraform plan
$ terraform apply # or terraform apply -auto-approve
```

If everything goes well, a EC2 instance with a IAM Role will be deployed, Prometheus and Thanos Sidecar will be deployed to your instance.

To get output afterwards, you can use:

```
$ terraform show -json | jq -r '.values.outputs.ip.value'
172.31.95.196
```

Or you can use:

```
$ terraform output -json ip | jq -r '.'
172.31.95.196
```

## Todo

Use jinja to templatize configs.
