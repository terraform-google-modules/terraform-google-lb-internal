/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# The forwarding rule resource needs the self_link but the firewall rules only need the name.
# Using a data source here to access both self_link and name by looking up the network name.
data "google_compute_network" "network" {
  name    = "${var.network}"
  project = "${var.network_project == "" ? var.project : var.network_project}"
}

data "google_compute_subnetwork" "network" {
  name    = "${var.subnetwork}"
  project = "${var.network_project == "" ? var.project : var.network_project}"
}

resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "${var.name}"
  region                = "${var.region}"
  network               = "${data.google_compute_network.network.self_link}"
  subnetwork            = "${data.google_compute_subnetwork.network.self_link}"
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${google_compute_region_backend_service.default.self_link}"
  ip_address            = "${var.ip_address}"
  ip_protocol           = "${var.ip_protocol}"
  ports                 = ["${var.ports}"]
  service_label         = "${var.service_label}"
}

resource "google_compute_region_backend_service" "default" {
  project          = "${var.project}"
  name             = "${var.name}"
  region           = "${var.region}"
  protocol         = "${var.ip_protocol}"
  timeout_sec      = 10
  session_affinity = "${var.session_affinity}"
  backend          = ["${var.backends}"]
  health_checks    = ["${element(compact(concat(google_compute_health_check.tcp.*.self_link,google_compute_health_check.http.*.self_link)), 0)}"]
}

resource "google_compute_health_check" "tcp" {
  count   = "${var.http_health_check ? 0 : 1}"
  project = "${var.project}"
  name    = "${var.name}-hc"

  tcp_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_health_check" "http" {
  count   = "${var.http_health_check ? 1 : 0}"
  project = "${var.project}"
  name    = "${var.name}-hc"

  http_health_check {
    port = "${var.health_port}"
  }
}

resource "google_compute_firewall" "default-ilb-fw" {
  project = "${var.network_project == "" ? var.project : var.network_project}"
  name    = "${var.name}-ilb-fw"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "${lower(var.ip_protocol)}"
    ports    = ["${var.ports}"]
  }

  source_tags = ["${var.source_tags}"]
  target_tags = ["${var.target_tags}"]
}

resource "google_compute_firewall" "default-hc" {
  project = "${var.network_project == "" ? var.project : var.network_project}"
  name    = "${var.name}-hc"
  network = "${data.google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["${var.health_port}"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["${var.target_tags}"]
}
