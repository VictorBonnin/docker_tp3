terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "example_network" {
  name = "example_network"
}

resource "docker_image" "nginx_image" {
  name = "nginx:1.27"
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.latest
  name  = "tutorial"
  
  networks_advanced {
    name = docker_network.example_network.name
  }

  ports {
    internal = 80
    external = 8080
  }
}