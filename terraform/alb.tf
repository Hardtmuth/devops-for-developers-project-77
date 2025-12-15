data "yandex_cm_certificate" "cert" {
  certificate_id = "fpqufjj6herjh0saml5n"
}

resource "yandex_alb_load_balancer" "alb" {
  name = "hexly-devops-alb"

  network_id = yandex_vpc_network.network-hexly-devops.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      redirects {
        http_to_https = true
      }
    }
  }

  listener {
    name = "https-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        certificate_ids = [data.yandex_cm_certificate.cert.certificate_id]
        http_handler {
          http_router_id = yandex_alb_http_router.router.id
        }
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }

}

resource "yandex_alb_http_router" "router" {
  name = "hexly-devops-http-router"
}

resource "yandex_alb_virtual_host" "vh" {
  http_router_id = yandex_alb_http_router.router.id
  name           = "hexly-devops-vh"

  route {
    name = "proxy-to-backend"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend_group.id
        timeout          = "60s"
        idle_timeout     = "60s"
      }
    }
  }
}

resource "yandex_alb_backend_group" "backend_group" {
  name = "hexly-devops-backend-group"

  http_backend {
    name          = "hexly-devops-http-backend"
    port          = 3000
    target_group_ids = [yandex_alb_target_group.tg.id] 
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_target_group" "tg" {
  name = "hexly-devops-target-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    ip_address   = yandex_compute_instance.vm-1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    ip_address   = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
}

output "alb_http_external_ip" {
  value = yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Внешний IPv4‑адрес балансировщика для listener 'http-listener'"
}