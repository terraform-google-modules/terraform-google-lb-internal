/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider google {
  version = "~> 3.14.0"
}

provider "random" {
  version = "~> 2.0"
}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

locals {
  random_suffix = random_string.suffix.result
  resource_name = "ilb-minimal-${local.random_suffix}"
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 8081
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
  }
}

resource "google_compute_network" "test" {
  project                 = var.project_id
  name                    = local.resource_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test" {
  project       = var.project_id
  name          = local.resource_name
  network       = google_compute_network.test.name
  region        = var.region
  ip_cidr_range = "10.2.0.0/16"
}

module "test_ilb" {
  source       = "../../"
  project      = var.project_id
  network      = google_compute_network.test.name
  subnetwork   = google_compute_subnetwork.test.name
  region       = var.region
  name         = local.resource_name
  ports        = ["8080"]
  source_tags  = ["source-tag-foo"]
  target_tags  = ["target-tag-bar"]
  backends     = []
  health_check = local.health_check
}
