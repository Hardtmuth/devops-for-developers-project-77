resource "datadog_synthetics_test" "app_liveness_check" {
  name    = "Check http (HTTP GET)"
  type    = "api"
  subtype = "http"
  status  = "live"
  message = "hexlydevops.space is NOT avaliable"

  locations = ["aws:eu-central-1", "aws:us-east-1"] 

  request_definition {
    method = "GET"
    url    = "https://hexlydevops.space"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  options_list {
    tick_every = 300
    monitor_options {
      renotify_interval = 60
    }
  }
}
