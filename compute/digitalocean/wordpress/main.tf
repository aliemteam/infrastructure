data "digitalocean_ssh_key" "dsifford_desktop" {
  name = "dsifford@archlinux_desktop"
}

data "digitalocean_ssh_key" "dsifford_macbook" {
  name = "dsifford@macbook-pro"
}

resource "digitalocean_droplet" "wordpress" {
  image              = "docker-18-04"
  name               = "${var.domain}"
  region             = "${var.region}"
  size               = "${var.size}"
  backups            = true
  monitoring         = true
  private_networking = true

  ssh_keys = [
    "${data.digitalocean_ssh_key.dsifford_desktop.id}",
    "${data.digitalocean_ssh_key.dsifford_macbook.id}",
  ]

  connection {
    type        = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get update",
      "apt-get upgrade -y docker-ce",
      "apt-get install -y tree",
      "curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose",
      "chmod +x /usr/local/bin/docker-compose",
      "bash -c 'mkdir -p /app/{data,wp-content/{plugins,uploads,themes/${var.domain}}}'",
      "{ echo alias d='docker'; echo alias dc='docker-compose'; } >> ~/.bashrc",
    ]
  }

  provisioner "file" {
    source      = ".env"
    destination = "/app/.env"
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/app/docker-compose.yml"
  }

  provisioner "file" {
    source      = "lib/production.yml"
    destination = "/app/docker-compose.override.yml"
  }

  provisioner "file" {
    source      = "data/database.sql"
    destination = "/app/data/database.sql"
  }

  provisioner "file" {
    source      = "wp-content"
    destination = "/app"
  }

  provisioner "file" {
    source      = "dist/"
    destination = "/app/wp-content/themes/${var.domain}"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /app",
      "docker-compose up -d",
    ]
  }
}
