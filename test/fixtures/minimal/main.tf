/**
 * Copyright 2018 Google LLC
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
  version = "~> 1.20"
  project = "${var.project_name}"
  region  = "${var.region}"
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
  random_suffix = "${random_string.suffix.result}"
  resource_name = "ilb-minimal-${local.random_suffix}"
}

resource "google_project_service" "test" {
  service            = "compute.googleapis.com"
  disable_on_destroy = "false"
}

resource "google_compute_network" "test" {
  name                    = "${local.resource_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test" {
  name          = "${local.resource_name}"
  network       = "${google_compute_network.test.name}"
  region        = "${var.region}"
  ip_cidr_range = "10.2.0.0/16"
}

module "test_ilb" {
  source      = "../../.."
  network     = "${google_compute_network.test.name}"
  subnetwork  = "${google_compute_subnetwork.test.name}"
  region      = "${var.region}"
  name        = "${local.resource_name}"
  ports       = ["8080"]
  health_port = "8081"
  source_tags = ["source-tag-foo"]
  target_tags = ["target-tag-bar"]
  backends    = []
}
