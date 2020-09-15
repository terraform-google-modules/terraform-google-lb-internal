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
locals {
  create_http_forward     = var.enable_http_proxy || var.https_redirect
}

data "google_compute_network" "network" {
  name    = var.network
  project = var.network_project == "" ? var.project : var.network_project
}

data "google_compute_subnetwork" "network" {
  name    = var.subnetwork
  project = var.network_project == "" ? var.project : var.network_project
  region  = var.region
}

resource "google_compute_region_target_http_proxy" "default" {
  count   = local.create_http_forward ? 1 : 0
  project = var.project
  region  = var.region
  name    = "${var.name}-internal-http"
  url_map = var.create_url_map ? google_compute_region_url_map.default[0].self_link : var.url_map
}

resource "google_compute_region_target_https_proxy" "default" {
  count            = length(var.ssl_certificate) > 0 ? 1 : 0
  project          = var.project
  region           = var.region
  name             = "${var.name}-internal-https"
  url_map          = var.create_url_map ? google_compute_region_url_map.default[0].self_link : var.url_map
  ssl_certificates = var.ssl_certificate
}

resource "google_compute_region_url_map" "default" {
  count           = var.create_url_map ? 1 : 0
  project         = var.project
  region          = var.region
  name            = "${var.name}-internal-lb"
  default_service = google_compute_region_backend_service.default[keys(var.backends)[0]].self_link
}

resource "google_compute_forwarding_rule" "http" {
  count                 = local.create_http_forward ? 1 : 0
  project               = var.project
  name                  = "${var.name}-http"
  region                = var.region
  network               = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.network.self_link
  target                = google_compute_region_target_http_proxy.default[0].id
  allow_global_access   = var.global_access
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  port_range            = 80
  service_label         = var.service_label
}

resource "google_compute_forwarding_rule" "https" {
  count                 = length(var.ssl_certificate) > 0 ? 1 : 0
  project               = var.project
  name                  = "${var.name}-https"
  region                = var.region
  network               = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.network.self_link
  target                = google_compute_region_target_https_proxy.default[0].id
  allow_global_access   = var.global_access
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  port_range            = 443
  service_label         = var.service_label
}

resource "google_compute_url_map" "https_redirect" {
  project = var.project
  count   = var.https_redirect ? 1 : 0
  name    = "${var.name}-https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_region_backend_service" "default" {
  project          = var.project
  for_each         = var.backends
  name             = var.health_check["type"] == "tcp" ? "${var.name}-with-tcp-hc-${each.key}" : "${var.name}-with-http-hc-${each.key}"
  region           = var.region
  protocol         = var.backend_protocol
  timeout_sec      = 10
  session_affinity = var.session_affinity
  port_name        = var.port_name
  load_balancing_scheme = "INTERNAL_MANAGED"
  dynamic "backend" {
    for_each = toset(each.value["backend"])
    content {
      group           = lookup(backend.value, "group", null)
      description     = lookup(backend.value, "description", null)
      balancing_mode  = lookup(backend.value, "balancing_mode", null)
      capacity_scaler = lookup(backend.value, "capacity_scaler", null)
    }
  }
  health_checks = [var.health_check["type"] == "tcp" ? google_compute_region_health_check.tcp[0].self_link : google_compute_region_health_check.http[0].self_link]
}

resource "google_compute_region_health_check" "tcp" {
  count   = var.health_check["type"] == "tcp" ? 1 : 0
  project = var.project
  region  = var.region
  name    = "${var.name}-hc-tcp"

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
}

resource "google_compute_region_health_check" "http" {
  count   = var.health_check["type"] == "http" ? 1 : 0
  project = var.project
  region  = var.region
  name    = "${var.name}-hc-http"

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
}

resource "google_compute_firewall" "default-ilb-fw" {
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

