variable "db_password" {
  type        = string
  sensitive   = true
  description = "Пароль для пользователя БД"
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

resource "yandex_mdb_postgresql_cluster" "pg_single" {
  name        = "hexly-devops-postgres"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.network-hexly-devops.id


  config {
    version = "14"


    resources {
      resource_preset_id = "b1.medium"
      disk_type_id       = "network-hdd"
      disk_size          = "10"
    }

    access {
      web_sql   = false
      data_lens = false
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-hexly-devops.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_postgresql_database" "pg_db" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_single.id
  name       = var.db_name
  owner      = var.db_user
}

resource "yandex_mdb_postgresql_user" "pg_user" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_single.id
  name       = var.db_user
  password   = var.db_password
}

output "cluster_id" {
  value = yandex_mdb_postgresql_cluster.pg_single.id
}

output "db_host" {
  value = yandex_mdb_postgresql_cluster.pg_single.host[0].fqdn
}

output "db_port" {
  value = 6432
}

output "db_name" {
  value = yandex_mdb_postgresql_database.pg_db.name
}

output "db_user" {
  value = yandex_mdb_postgresql_user.pg_user.name
}
