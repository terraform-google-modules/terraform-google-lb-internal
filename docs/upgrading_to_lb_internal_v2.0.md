# Upgrading to Load Balancer Internal v2.0 (from v1.X)

The v2.0 release of Load Balancer Internal is a backwards incompatible release. The string `health_port` and boolean `http_health_check` arguments were replaced with the new object type parameter called `health_check`

## Migration Instructions

### Health Port and HTTP Health Check Arguments Changes

Version 1.X of Load Balancer Internal used the required `health_port` string variable defining a port to perform health checks on and an optional `http_health_check` boolean variable to set whether the health checks should be performed via HTTP or TCP

```hcl
module "gce-ilb" {
  source            = "GoogleCloudPlatform/lb-internal/google"
  version           = "~> 1.0"
  region            = "${var.region}"
  name              = "group2-ilb"
  ports             = ["80"]
  health_port       = "80"
  http_health_check = "true"
  source_tags       = ["allow-group1"]
  target_tags       = ["allow-group2", "allow-group3"]
  backends          = [
    { group = "${module.mig2.instance_group}", description = "" },
    { group = "${module.mig3.instance_group}", description = "" },
  ]
}
```

Version 2.X of Load Balancer Internal uses the new parameter named `health_check`:

```hcl
module "gce-ilb" {
  source       = "terraform-google-modules/lb-internal/google"
  version      = "~> 2.0"
  region       = var.region
  name         = "group2-ilb"
  ports        = ["80"]
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    request             = ""
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    port_name           = "health-check-port"
    request_path        = "/"
    host                = "1.2.3.4"
  }
  source_tags  = ["allow-group1"]
  target_tags  = ["allow-group2", "allow-group3"]
  backends     = [
    { group = module.mig2.instance_group, description = "" },
    { group = module.mig3.instance_group, description = "" },
  ]
}
```

