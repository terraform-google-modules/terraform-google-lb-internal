# Upgrading to v6.0 (from v5.x)

The v6.0 release is a backwards incompatible release.

# Minimum Terraform Version
Minimum terraform version required is 1.3

# ports
In v5 and below, there was no mention of the mutual exclusivity between the `ports` and `all_ports` arguments. When a consumer wanted to use the `all_ports` argument, they had to go through a process of trial and error to figure out how to successfully deploy a load balancer with this module. To simplify usage of the `all_ports` argument, the `ports` argument is no longer required and now defaults to `null`.

## Upgrade Guidance

The two examples below can be referenced for using each argument.

### Using the `ports` argument

```hcl
module "gce-ilb" {
  source            = "GoogleCloudPlatform/lb-internal/google"
  version           = "~> 6.0"
  region            = var.region
  name              = "group2-ilb"
  ports             = ["80"]
  source_tags       = ["allow-group1"]
  target_tags       = ["allow-group2", "allow-group3"]

  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
    enable_log          = false
  }

  backends = [
    {
      group       = module.mig2.instance_group
      description = ""
      failover    = false
    },
    {
      group       = module.mig3.instance_group
      description = ""
      failover    = false
    },
  ]
}
```

### Using the `all_ports` argument

```hcl
module "gce-ilb" {
  source            = "GoogleCloudPlatform/lb-internal/google"
  version           = "~> 6.0"
  region            = var.region
  name              = "group2-ilb"
  all_ports         = true
  source_tags       = ["allow-group1"]
  target_tags       = ["allow-group2", "allow-group3"]

  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
    enable_log          = false
  }

  backends = [
    {
      group       = module.mig2.instance_group
      description = ""
      failover    = false
    },
    {
      group       = module.mig3.instance_group
      description = ""
      failover    = false
    },
  ]
}
```
