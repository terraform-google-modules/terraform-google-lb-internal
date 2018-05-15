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

variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable region {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable network {
  description = "Name of the network to create resources in."
  default     = "default"
}

variable subnetwork {
  description = "Name of the subnetwork to create resources in."
  default     = "default"
}

variable network_project {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project."
  default     = ""
}

variable name {
  description = "Name for the forwarding rule and prefix for supporting resources."
}

variable backends {
  description = "List of backends, should be a map of key-value pairs for each backend, mush have the 'group' key."
  type        = "list"
}

variable session_affinity {
  description = "The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`."
  default     = "NONE"
}

variable ports {
  description = "List of ports range to forward to backend services. Max is 5."
  type        = "list"
}

variable http_health_check {
  description = "Set to true if health check is type http, otherwise health check is tcp."
  default     = false
}

variable health_port {
  description = "Port to perform health checks on."
}

variable source_tags {
  description = "List of source tags for traffic between the internal load balancer."
  type        = "list"
}

variable target_tags {
  description = "List of target tags for traffic between the internal load balancer."
  type        = "list"
}

variable ip_address {
  description = "IP address of the internal load balancer, if empty one will be assigned. Default is empty."
  default     = ""
}

variable ip_protocol {
  description = "The IP protocol for the backend and frontend forwarding rule. TCP or UDP."
  default     = "TCP"
}
