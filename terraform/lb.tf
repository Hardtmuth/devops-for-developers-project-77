resource "yandex_lb_network_load_balancer" "hexly-devops-nlb" {
  name        = "hexly-devops-nlb"
  description = "Hexly DevOps Network Load Balancer"

  listener {
    name   = "http-listener"
    port   = 80
    protocol = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name   = "https-listener"
    port   = 443
    protocol = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.hexly-devops-tg.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 8080
        path = "/health"
      }
    }
  }

  deletion_protection = false
}

resource "yandex_lb_target_group" "hexly-devops-tg" {
  name = "hexly-devops-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    address   = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    address   = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
}

output "nlb_http_external_ip" {
  value = [
    for listener in yandex_lb_network_load_balancer.hexly-devops-nlb.listener :
      [
        for addr_spec in listener.external_address_spec :
          addr_spec.address
        if addr_spec.ip_version == "ipv4"  # Фильтруем IPv4 (опционально)
      ][0]
    if listener.name == "http-listener"
  ][0]
  description = "Внешний IPv4‑адрес балансировщика для listener 'http-listener'"
}
