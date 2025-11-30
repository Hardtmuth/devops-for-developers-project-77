terraform {
  backend "s3" {
    endpoint                    = "https://storage.yandexcloud.net"
    region                      = "ru-central1"
    key                         = "hexly-devops-remote-state"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}