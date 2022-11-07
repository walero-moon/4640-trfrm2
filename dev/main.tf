terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

#Configure the Digital cean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "ssh_key" {
  name = "spirit-digital-ocean"
}

data "digitalocean_project" "lab_project" {
  name = "ACIT 4640"
}

# Create a new tag
resource "digitalocean_tag" "lab_tag" {
  name = "Lab"
}

# Create a new vpc
resource "digitalocean_vpc" "lab_vpc" {
  name   = "ACIT4640"
  region = var.region
}

# Create a new droplet
resource "digitalocean_droplet" "lab_droplet" {
  image    = "rockylinux-9-x64"
  count    = var.droplet_count
  name     = "lab-${count.index + 1}"
  tags     = [digitalocean_tag.lab_tag.id]
  region   = var.region
  size     = "s-1vcpu-512mb-10gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
  vpc_uuid = digitalocean_vpc.lab_vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

# Attach the droplet to the project
resource "digitalocean_project_resources" "lab_project_resources" {
  project = data.digitalocean_project.lab_project.id
  resources = flatten([
    digitalocean_droplet.lab_droplet.*.urn
  ])
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_tag = "Lab"
  vpc_uuid = digitalocean_vpc.lab_vpc.id
}

# Print IP address of new droplet
output "ip_address" {
  value = flatten([digitalocean_droplet.lab_droplet.*.ipv4_address])
}