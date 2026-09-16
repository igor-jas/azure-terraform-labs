terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "server_password" {
  type      = string
  sensitive = true
}

provider "docker" {}

resource "docker_image" "server_base" {
  name = "capstone-ssh-server:latest"
  build {
    context = "../docker-server"
    build_args = {
      SERVER_PASSWORD = var.server_password
    }
  }
}

resource "docker_container" "capstone_server" {
  name       = "capstone-server"
  image      = docker_image.server_base.image_id
  privileged = true

  ports {
    internal = 22
    external = 2222
  }

  ports {
    internal = 5000
    external = 5001
  }
}

