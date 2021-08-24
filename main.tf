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

# The forwarding rule resource needs the self_link but the firewall rules only need the name.
# Using a data source here to access both self_link and name by looking up the network name.
data "google_compute_network" "network" {
  name    = var.network
  project = var.network_project == "" ? var.project : var.network_project
}

data "google_compute_subnetwork" "network" {
  name    = var.subnetwork
  project = var.network_project == "" ? var.project : var.network_project
  region  = var.region
}

resource "google_compute_forwarding_rule" "default" {
  project               = var.project
  name                  = var.name
  region                = var.region
  network               = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.network.self_link
  allow_global_access   = var.global_access
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.default.self_link
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  ports                 = var.ports
  all_ports             = var.all_ports
  service_label         = var.service_label
}

resource "google_compute_region_backend_service" "default" {
  project  = var.project
  name     = var.health_check["type"] == "tcp" ? "${var.name}-with-tcp-hc" : "${var.name}-with-http-hc"
  region   = var.region
  protocol = var.ip_protocol
  # Do not try to add timeout_sec, as it is has no impact. See https://github.com/terraform-google-modules/terraform-google-lb-internal/issues/53#issuecomment-893427675
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  session_affinity                = var.session_affinity
  dynamic "backend" {
    for_each = var.backends
    content {
      group       = lookup(backend.value, "group", null)
      description = lookup(backend.value, "description", null)
      failover    = lookup(backend.value, "failover", null)
    }
  }
  health_checks = [var.health_check["type"] == "tcp" ? google_compute_health_check.tcp[0].self_link : google_compute_health_check.http[0].self_link]
}

resource "google_compute_health_check" "tcp" {
  provider = google-beta
  count    = var.health_check["type"] == "tcp" ? 1 : 0
  project  = var.project
  name     = "${var.name}-hc-tcp"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  tcp_health_check {
    port         = var.health_check["port"]
    request      = var.health_check["request"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_health_check" "http" {
  provider = google-beta
  count    = var.health_check["type"] == "http" ? 1 : 0
  project  = var.project
  name     = "${var.name}-hc-http"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  http_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_firewall" "default-ilb-fw" {
  count   = var.create_backend_firewall ? 1 : 0
  project = var.network_project == "" ? var.project : var.network_project
  name    = "${var.name}-ilb-fw"
  network = data.google_compute_network.network.name

  allow {
    protocol = lower(var.ip_protocol)
    ports    = var.ports
  }

  source_ranges           = var.source_ip_ranges
  source_tags             = var.source_tags
  source_service_accounts = var.source_service_accounts
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts
}

resource "google_compute_firewall" "default-hc" {
  count   = var.create_health_check_firewall ? 1 : 0
  project = var.network_project == "" ? var.project : var.network_project
  name    = "${var.name}-hc"
  network = data.google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = [var.health_check["port"]]
  }

  source_ranges           = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts
}
