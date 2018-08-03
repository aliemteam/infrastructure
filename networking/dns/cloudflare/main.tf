provider "cloudflare" {
  email = "${var.email}"
  token = "${var.token}"
}

# Address Record: domain.com
resource "cloudflare_record" "a" {
  domain  = "${var.domain}"
  name    = "@"
  type    = "A"
  value   = "${var.ipv4}"
  ttl     = 1
  proxied = true
}

# Address Record: www.domain.com
resource "cloudflare_record" "a-www" {
  domain  = "${var.domain}"
  name    = "www"
  type    = "A"
  value   = "${var.ipv4}"
  ttl     = 1
  proxied = true
}

#
# GSuite Records
#

resource "cloudflare_record" "mx-gsuite-aspmx" {
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "aspmx.l.google.com"
  priority = 1
}

resource "cloudflare_record" "mx-gsuite-alt1" {
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  priority = 5
}

resource "cloudflare_record" "mx-gsuite-alt2" {
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  priority = 5
}

resource "cloudflare_record" "mx-gsuite-alt3" {
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
  priority = 10
}

resource "cloudflare_record" "mx-gsuite-alt4" {
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
  priority = 10
}
