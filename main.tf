resource "aws_lightsail_key_pair" "this" {
}

resource "aws_lightsail_instance" "this" {
  availability_zone = "${var.aws_region}a"
  name              = "webserver"
  bundle_id         = "nano_3_0"
  blueprint_id      = "debian_12"
  key_pair_name     = aws_lightsail_key_pair.this.name
  user_data         = "echo ${base64encode(local.installation)} | base64 -d | sh"
}

resource "aws_lightsail_instance_public_ports" "this" {
  instance_name = aws_lightsail_instance.this.name
  port_info {
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidrs      = ["0.0.0.0/0"]
    ipv6_cidrs = ["::/0"]
  }
  port_info {
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidrs      = ["0.0.0.0/0"]
    ipv6_cidrs = ["::/0"]
  }
  port_info {
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    cidrs      = ["0.0.0.0/0"]
    ipv6_cidrs = ["::/0"]
  }
}

resource "aws_lightsail_static_ip" "this" {
  name = "staticip"
}

resource "aws_lightsail_static_ip_attachment" "this" {
  static_ip_name = aws_lightsail_static_ip.this.id
  instance_name  = aws_lightsail_instance.this.id
}

resource "aws_lightsail_domain" "this" {
  domain_name = "girlsday.${var.dnszone}"
  provider    = aws.us_east_1
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_lightsail_domain_entry" "ipv4" {
  for_each    = toset(["", "www"])
  domain_name = aws_lightsail_domain.this.domain_name
  name        = each.key
  type        = "A"
  target      = aws_lightsail_static_ip.this.ip_address
  provider    = aws.us_east_1
}

resource "aws_lightsail_domain_entry" "ipv6" {
  for_each    = toset(["", "www"])
  domain_name = aws_lightsail_domain.this.domain_name
  name        = each.key
  type        = "AAAA"
  target      = aws_lightsail_instance.this.ipv6_addresses[0]
  provider    = aws.us_east_1
}



