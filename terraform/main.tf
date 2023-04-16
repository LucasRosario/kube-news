terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Create a new Web Droplet in the nyc1 region
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  version = "1.26.3-do.0"

  node_pool {
    name       = "defautl"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "do_token" {
  default = "dop_v1_64bcf75706378730bca5fc39d0a3212fb28f9608566307e03427aae943e49043"
}

variable "ssh_key_name" {
  default = ""
}

variable "region" {
  default = ""
}

output "jenkins_ip" {
    value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kube.config.yaml"
}