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

# Mail Exchange Records: Gsuite / Gmail
resource "cloudflare_record" "mx-gsuite" {
  count    = 5
  domain   = "${var.domain}"
  name     = "@"
  type     = "MX"
  value    = "${count.index == 0 ? "" : "alt${count.index + 1}."}aspmx.l.google.com"
  priority = "${abs(element(list("1", "5", "5", "10", "10"), count.index))}"
}
