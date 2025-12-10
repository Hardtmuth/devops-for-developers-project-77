resource "yandex_compute_disk" "hdd-vm1" {
  name     = "drive-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = data.yandex_compute_image.os_image.id
}

resource "yandex_compute_disk" "hdd-vm2" {
  name     = "drive-2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = data.yandex_compute_image.os_image.id
}

resource "yandex_compute_instance" "vm-1" {
  name = "app-01"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.hdd-vm1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("../key/yc.pub")}"
  }
}

resource "yandex_compute_instance" "vm-2" {
  name = "app-02"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.hdd-vm2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("../key/yc.pub")}"
  }
}

resource "yandex_vpc_network" "network-hexly-devops" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-hexly-devops" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-hexly-devops.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}
output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
