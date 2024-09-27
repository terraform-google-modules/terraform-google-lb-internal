# Upgrading to v7.0 (from v6.x)

The v7.0 release is a backwards incompatible release.

# balancing_mode for backends

The newest version of `google_compute_region_backend_service` requires a `balancing_mode` be set for backends. Therefore a default `balancing_mode` of `CONNECTION` is used in the dynamic `backend` block in v7.0 of this module. The full list of balancing modes is available in the [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service#balancing_mode).

## Upgrade Guidance

In this example, `balancing_mode` is *not* provided in the `backends` block. Therefore, it will default to `CONNECTION`.

```hcl
module "gce_ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = ">= 4.4.0"
  project      = var.project_id
  region       = var.region
  name         = "tf-ilb"
  network      = "testnetwork"
  subnetwork   = "testsubnet"
  ports        = ["xxxx"]
  health_check = local.health_check
  source_tags  = ["xxxxxx"]
  target_tags  = ["xxxxxx"]
  backends = [
    for x in google_compute_instance_group.test_ig[*] : {
      group          = x.id
      description    = ""
      failover       = false
    }
  ]
  create_backend_firewall      = "true"
  create_health_check_firewall = "true"
}
```

This is an example where the `balancing_mode` is explicitly provided:

```hcl
module "gce_ilb" {
  source       = "GoogleCloudPlatform/lb-internal/google"
  version      = ">= 4.4.0"
  project      = var.project_id
  region       = var.region
  name         = "tf-ilb"
  network      = "testnetwork"
  subnetwork   = "testsubnet"
  ports        = ["xxxx"]
  health_check = local.health_check
  source_tags  = ["xxxxxx"]
  target_tags  = ["xxxxxx"]
  backends = [
    for x in google_compute_instance_group.test_ig[*] : {
      group          = x.id
      description    = ""
      failover       = false
      balancing_mode = "CONNECTION"
    }
  ]
  create_backend_firewall      = "true"
  create_health_check_firewall = "true"
}
```
