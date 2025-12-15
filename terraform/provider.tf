terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.82"
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

variable "dd_api_key" {}
variable "dd_app_key" {}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
  api_url  = "https://api.datadoghq.eu"
}
