variable "digitalocean_image" {
  # See `doctl compute image list-application --public` for list
  description = "The slug of the image to use for the droplet."
}

variable "domain" {
  description = "The domain name of the site."
}

variable "region" {
  description = "DigitalOcean datacenter region (Default: San Francisco 2)."
  default     = "sfo2"
}

variable "size" {
  description = "Droplet size. (Default: 2GB RAM, 50GB Disk - $10/mo)."
  default     = "s-1vcpu-2gb"
}
