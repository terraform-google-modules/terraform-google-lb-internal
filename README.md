# Internal Load Balancer Terraform Module

Modular Internal Load Balancer for GCE using forwarding rules.

## Usage

```ruby
module "gce-ilb" {
  source         = "github.com/GoogleCloudPlatform/terraform-google-lb-internal"
  region         = "${var.region}"
  name           = "group2-ilb"
  ports          = ["${module.mig2.service_port}"]
  health_port    = "${module.mig2.service_port}"
  source_tags    = ["${module.mig1.target_tags}"]
  target_tags    = ["${module.mig2.target_tags}","${module.mig3.target_tags}"]
  backends       = [
    { group = "${module.mig2.instance_group}" },
    { group = "${module.mig3.instance_group}" },
  ]
}
```

### Input variables

- `region` (optional): Region for cloud resources. Default is `us-central1`.
- `network` (optional): Name of the network to create resources in. Default is `default`.
- `name` (required): Name for the forwarding rule and prefix for supporting resources.
- `backends` (optional): List of backends, should be a map of key-value pairs for each backend, mush have the 'group' key.
- `session_affinity`(optional): The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`.
- `ports` (required): List of ports range to forward to backend services. Max is 5.
- `health_port` (requierd): Port to perform health checks on.
- `source_tags`: (required): List of source tags for traffic between the internal load balancer.
- `target_tags`: (required): List of target tags for traffic between the internal load balancer.
- `ip_address` (optional) IP address of the internal load balancer, if empty one will be assigned. Default is empty.

### Output variables

- `ip_address`: The internal IP assigned to the regional fowarding rule.

## Resources created

**Figure 1.** *diagram of terraform resources*

![architecture diagram](./diagram.png)

- [`google_compute_forwarding_rule.default`](https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html): The internal regional forwarding rule.
- [`google_compute_region_backend_service.default`](https://www.terraform.io/docs/providers/google/r/compute_region_backend_service.html): The backend service registered to the given `instance_group`.
- [`google_compute_health_check.default`](https://www.terraform.io/docs/providers/google/r/compute_health_check.html): The TCP health check for the `instance_group` targets on the `service_port`.
- [`google_compute_firewall.default-ilb-fw`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html): Firewall rule that allows traffic from the `source_tags` resources to `target_tags` on the `service_port`.
- [`google_compute_firewall.default-hc`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html): Firewall rule that allows traffic for health checks to the `target_tags` resources.