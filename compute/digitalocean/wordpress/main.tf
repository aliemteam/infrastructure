data "digitalocean_ssh_key" "dsifford_desktop" {
  name = "dsifford@archlinux_desktop"
}

data "digitalocean_ssh_key" "dsifford_macbook" {
  name = "dsifford@macbook-pro"
}

resource "digitalocean_droplet" "wordpress" {
  image              = var.image
  name               = var.domain
  region             = var.region
  size               = var.size
  backups            = true
  monitoring         = true

  ssh_keys = [
    data.digitalocean_ssh_key.dsifford_desktop.id,
    data.digitalocean_ssh_key.dsifford_macbook.id,
  ]

  connection {
    host        = self.ipv4_address
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "apt-get update",
      "apt-get install --upgrade -y docker-ce tree",
      "bash -c 'mkdir -p /app/{data,etc,wp-content/{plugins,uploads,themes/${var.domain}}}'",
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
    source      = "docker-compose.prod.yml"
    destination = "/app/docker-compose.override.yml"
  }

  provisioner "file" {
    source      = "etc"
    destination = "/app"
  }

  provisioner "file" {
    source      = "wp-content"
    destination = "/app"
  }

  provisioner "file" {
    source      = "dist/"
    destination = "/app/wp-content/themes/${var.domain}"
  }

  provisioner "file" {
    source      = "data/database.sql"
    destination = "/app/data/database.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /app",
      "docker-compose up -d",
    ]
  }
}

