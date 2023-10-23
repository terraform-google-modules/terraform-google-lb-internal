# Internal Load Balancer Terraform Module
Modular Internal Load Balancer for GCE using forwarding rules.

### Load Balancer Types
* [TCP load balancer](https://github.com/terraform-google-modules/terraform-google-lb)
* [HTTP/S load balancer](https://github.com/terraform-google-modules/terraform-google-lb-http)
* **Internal load balancer**

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v2.3.0](https://registry.terraform.io/modules/terraform-google-modules/-lb-internal/google/v2.3.0).

## Upgrading

The current version is 2.X. The following guides are available to assist with upgrades:

- [1.X -> 2.0](./docs/upgrading_to_lb_internal_v2.0.md)

## Usage

```hcl
module "gce-ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = "~> 2.0"
  region       = var.region
  name         = "group2-ilb"
  ports        = ["80"]
  health_check = var.health_check
  source_tags  = ["allow-group1"]
  target_tags  = ["allow-group2", "allow-group3"]
  backends     = [
    { group = module.mig2.instance_group, description = "", failover = false },
    { group = module.mig3.instance_group, description = "", failover = false },
  ]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| all\_ports | Boolean for all\_ports setting on forwarding rule. | `bool` | `null` | no |
| backends | List of backends, should be a map of key-value pairs for each backend, must have the 'group' key. | `list(any)` | n/a | yes |
| connection\_draining\_timeout\_sec | Time for which instance will be drained | `number` | `null` | no |
| create\_backend\_firewall | Controls if firewall rules for the backends will be created or not. Health-check firewall rules are controlled separately. | `bool` | `true` | no |
| create\_health\_check\_firewall | Controls if firewall rules for the health check will be created or not. If this rule is not present backend healthcheck will fail. | `bool` | `true` | no |
| firewall\_enable\_logging | Controls if firewall rules that are created are to have logging configured. This will be ignored for firewall rules that are not created. | `bool` | `false` | no |
| global\_access | Allow all regions on the same VPC network access. | `bool` | `false` | no |
| health\_check | Health check to determine whether instances are responsive and able to do work | <pre>object({<br>    type                = string<br>    check_interval_sec  = number<br>    healthy_threshold   = number<br>    timeout_sec         = number<br>    unhealthy_threshold = number<br>    response            = string<br>    proxy_header        = string<br>    port                = number<br>    port_name           = string<br>    request             = string<br>    request_path        = string<br>    host                = string<br>    enable_log          = bool<br>  })</pre> | n/a | yes |
| ip\_address | IP address of the internal load balancer, if empty one will be assigned. Default is empty. | `string` | `null` | no |
| ip\_protocol | The IP protocol for the backend and frontend forwarding rule. TCP or UDP. | `string` | `"TCP"` | no |
| labels | The labels to attach to resources created by this module. | `map(string)` | `{}` | no |
| name | Name for the forwarding rule and prefix for supporting resources. | `string` | n/a | yes |
| network | Name of the network to create resources in. | `string` | `"default"` | no |
| network\_project | Name of the project for the network. Useful for shared VPC. Default is var.project. | `string` | `""` | no |
| ports | List of ports range to forward to backend services. Max is 5. | `list(string)` | n/a | yes |
| project | The project to deploy to, if not set the default provider project is used. | `string` | `""` | no |
| region | Region for cloud resources. | `string` | `"us-central1"` | no |
| service\_label | Service label is used to create internal DNS name | `string` | `null` | no |
| session\_affinity | The session affinity for the backends example: NONE, CLIENT\_IP. Default is `NONE`. | `string` | `"NONE"` | no |
| source\_ip\_ranges | List of source ip ranges for traffic between the internal load balancer. | `list(string)` | `null` | no |
| source\_service\_accounts | List of source service accounts for traffic between the internal load balancer. | `list(string)` | `null` | no |
| source\_tags | List of source tags for traffic between the internal load balancer. | `list(string)` | n/a | yes |
| subnetwork | Name of the subnetwork to create resources in. | `string` | `"default"` | no |
| target\_service\_accounts | List of target service accounts for traffic between the internal load balancer. | `list(string)` | `null` | no |
| target\_tags | List of target tags for traffic between the internal load balancer. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forwarding\_rule | The forwarding rule self\_link. |
| forwarding\_rule\_id | The forwarding rule id. |
| ip\_address | The internal IP assigned to the regional forwarding rule. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Resources created

- [`google_compute_forwarding_rule.default`](https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule): The internal regional forwarding rule.
- [`google_compute_region_backend_service.default`](https://www.terraform.io/docs/providers/google/r/compute_region_backend_service): The backend service registered to the given `instance_group`.
- [`google_compute_health_check.tcp`](https://www.terraform.io/docs/providers/google/r/compute_health_check): The TCP health check for the `instance_group` targets.
- [`google_compute_health_check.http`](https://www.terraform.io/docs/providers/google/r/compute_health_check): The HTTP health check for the `instance_group` targets.
- [`google_compute_health_check.https`](https://www.terraform.io/docs/providers/google/r/compute_health_check): The HTTPS health check for the `instance_group` targets.
- [`google_compute_firewall.default-ilb-fw`](https://www.terraform.io/docs/providers/google/r/compute_firewall): Firewall rule that allows traffic from the `source_tags` resources to `target_tags` on the `service_port`.
- [`google_compute_firewall.default-hc`](https://www.terraform.io/docs/providers/google/r/compute_firewall): Firewall rule that allows traffic for health checks to the `target_tags` resources.
