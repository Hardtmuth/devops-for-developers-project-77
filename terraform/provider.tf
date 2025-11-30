terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "yc_token" {}
variable "folder_id" {}

provider "yandex" {
  zone = "ru-central1-a"
  token = var.yc_token
  folder_id = var.folder_id
}
