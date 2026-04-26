resource "docker_image" "makemkv" {
  name = "docker.io/jlesage/makemkv:latest"
}

resource "docker_container" "makemkv" {
  dns = ["8.8.8.8"]
  env = ["MAKEMKV_KEY=${var.keys.makemkv}"]
  image   = docker_image.makemkv.image_id
  name    = "makemkv"
  restart = "always"

  devices {
    host_path = "/dev/sg5"
  }

  devices {
    host_path = "/dev/sr0"
  }

  ports {
    external = 9900
    internal = 5800
  }

  volumes {
    container_path = "/config"
    host_path      = "/mnt/vault02/container_nas_lan_howard_estate/makemkv/config"
  }

  volumes {
    container_path = "/output"
    host_path      = "/mnt/vault01/media"
  }
}
