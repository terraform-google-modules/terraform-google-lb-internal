# Internal Load Balancer Terraform Module

Modular Internal Load Balancer for GCE using forwarding rules.

## Usage

```hcl
module "gce-ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  region       = var.region
  name         = "group2-ilb"
  ports        = [var.service_port]
  health_check = var.health_check
  source_tags  = var.source_tags
  target_tags  = var.target_tags
  backends     = [
    { group = module.mig2.instance_group },
    { group = module.mig3.instance_group },
  ]
}
```


## Resources created

- [`google_compute_forwarding_rule.default`](https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html): The internal regional forwarding rule.
- [`google_compute_region_backend_service.default`](https://www.terraform.io/docs/providers/google/r/compute_region_backend_service.html): The backend service registered to the given `instance_group`.
- [`google_compute_health_check.default`](https://www.terraform.io/docs/providers/google/r/compute_health_check.html): The TCP health check for the `instance_group` targets on the `service_port`.
- [`google_compute_firewall.default-ilb-fw`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html): Firewall rule that allows traffic from the `source_tags` resources to `target_tags` on the `service_port`.
- [`google_compute_firewall.default-hc`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html): Firewall rule that allows traffic for health checks to the `target_tags` resources.
