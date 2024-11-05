terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {}

# Création d'un réseau Docker pour permettre la communication entre les containers
resource "docker_network" "exemple2_network" {
  name = "exemple2_network"
}

# Image PHP-FPM
resource "docker_image" "php_fpm_image" {
  name = "php:8.3-fpm"
}

# Container PHP-FPM
resource "docker_container" "php_fpm_container" {
  image = docker_image.php_fpm_image.latest
  name  = "php-fpm"
  
  networks_advanced {
    name = docker_network.exemple2_network.name
  }

  # Variable d'environnement
  env = ["PHP_VAR=phpinfo"]

  # Remplacez ici par votre chemin absolu
  volumes {
    host_path      = "C:/Users/bonni/Documents/Ecole/Efrei/Dev_Ops/Cours 3/IaC/Exo2/php"
    container_path = "/var/www/html"
  }
}

# Image NGINX
resource "docker_image" "nginx_image" {
  name = "nginx:1.27"
}

# Container NGINX
resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.latest
  name  = "nginx"
  
  networks_advanced {
    name = docker_network.exemple2_network.name
  }

  # Redirection de ports
  ports {
    internal = 80
    external = 8080
  }

  # Remplacez ici par votre chemin absolu
  volumes {
    host_path      = "C:/Users/bonni/Documents/Ecole/Efrei/Dev_Ops/Cours 3/IaC/Exo2/php"
    container_path = "/usr/share/nginx/html"
  }

  # Commande pour lancer NGINX
  command = ["nginx", "-g", "daemon off;"]
}