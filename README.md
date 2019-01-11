# Internal Load Balancer Terraform Module

Modular Internal Load Balancer for GCE using forwarding rules.

## Usage

```ruby
module "gce-ilb" {
  source         = "GoogleCloudPlatform/lb-internal/google"
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

## Testing

This module comes packaged with tests with the goal of exercising the module in
various forms. In order to exercise them, you need the following:

1. A project in Google Cloud Platform.
2. An IAM user with credentials downloaded locally and set with the
  `GOOGLE_APPLICATION_CREDENTIALS` environment variable.
3. The following roles attached to that IAM user:
    ```text
    roles/compute.networkAdmin
    roles/compute.loadBalancerAdmin
    ```
4. A workstation with `docker` installed and running.

To run the tests, build a docker container using the following:

```bash
  make docker_build_all
```

Run the tests within a container with the following:

```bash
  make test_integration_docker
```

## Resources created

- [`google_compute_forwarding_rule.default`](https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html):
  The internal regional forwarding rule.
- [`google_compute_region_backend_service.default`](https://www.terraform.io/docs/providers/google/r/compute_region_backend_service.html):
  The backend service registered to the given `instance_group`.
- [`google_compute_health_check.default`](https://www.terraform.io/docs/providers/google/r/compute_health_check.html):
  The TCP health check for the `instance_group` targets on the `service_port`.
- [`google_compute_firewall.default-ilb-fw`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html):
  Firewall rule that allows traffic from the `source_tags` resources to `target_tags` on the `service_port`.
- [`google_compute_firewall.default-hc`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html):
  Firewall rule that allows traffic for health checks to the `target_tags` resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| backends | List of backends, should be a map of key-value pairs for each backend, mush have the 'group' key. | list | - | yes |
| health_port | Port to perform health checks on. | string | - | yes |
| http_health_check | Set to true if health check is type http, otherwise health check is tcp. | string | `false` | no |
| ip_address | IP address of the internal load balancer, if empty one will be assigned. Default is empty. | string | `` | no |
| ip_protocol | The IP protocol for the backend and frontend forwarding rule. TCP or UDP. | string | `TCP` | no |
| name | Name for the forwarding rule and prefix for supporting resources. | string | - | yes |
| network | Name of the network to create resources in. | string | `default` | no |
| network_project | Name of the project for the network. Useful for shared VPC. Default is var.project. | string | `` | no |
| ports | List of ports range to forward to backend services. Max is 5. | list | - | yes |
| project | The project to deploy to, if not set the default provider project is used. | string | `` | no |
| region | Region for cloud resources. | string | `us-central1` | no |
| session_affinity | The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`. | string | `NONE` | no |
| source_tags | List of source tags for traffic between the internal load balancer. | list | - | yes |
| subnetwork | Name of the subnetwork to create resources in. | string | `default` | no |
| target_tags | List of target tags for traffic between the internal load balancer. | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ip_address | The internal IP assigned to the regional fowarding rule. |
