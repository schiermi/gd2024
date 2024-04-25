locals {
  installation = <<-EOT
  apt-get update
  apt-get install -y --no-install-recommends --no-install-suggests apache2 libapache2-mod-php php-sqlite3 certbot python3-certbot-apache dnsutils sqlite3
  certbot --register-unsafely-without-email --agree-tos -d "www.${aws_lightsail_domain.this.domain_name}"
  sudo a2dismod mpm_event
  sudo a2enmod mpm_prefork
  sudo a2enmod php8.2
  chown -R admin:www-data /var/www/html
  chmod 775 /var/www/html

  EOT
}

resource "local_file" "key" {
  content         = aws_lightsail_key_pair.this.private_key
  filename        = "server.key"
  file_permission = "0400"
}

output "access" {
  value = {
    SSH = "ssh -iserver.key ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address}",
    SCP = "scp -iserver.key web/* ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address}:/var/www/html/"
  }
}

output "demo" {
  value = {
    READ_COUNTER       = "curl https://www.${aws_lightsail_domain.this.domain_name}/counter.php",
    INCREMENT_COUNTER  = "curl https://www.${aws_lightsail_domain.this.domain_name}/counter.php?action=increment",
    DECREMENT_COUNTER  = "curl https://www.${aws_lightsail_domain.this.domain_name}/counter.php?action=decrement",
    RESET_COUNTER      = "curl https://www.${aws_lightsail_domain.this.domain_name}/counter.php?action=reset",
    SERVER_SIDE_EVENTS = "curl https://www.${aws_lightsail_domain.this.domain_name}/counter.php?action=events",
    BROWSER_FRONTEND   = "https://www.${aws_lightsail_domain.this.domain_name}/",
  }
}
