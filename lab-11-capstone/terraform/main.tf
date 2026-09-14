terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "server_base" {
  name = "capstone-ssh-server:latest"
  build {
    context = "../docker-server"
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

