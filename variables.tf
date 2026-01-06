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

variable "project_id" {
  description = "The project_id to deploy to."
  type        = string
}

variable "region" {
  description = "Region for cloud resources."
  type        = string
}

variable "global_access" {
  description = "Allow all regions on the same VPC network access."
  type        = bool
  default     = false
}

variable "network" {
  description = "Name of the network to create resources in."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  type        = string
  default     = "default"
}

variable "network_project" {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project_id."
  type        = string
  default     = ""
}

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources."
  type        = string
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."
  type        = list(any)
}

variable "session_affinity" {
  description = "The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`."
  type        = string
  default     = "NONE"
}

variable "ports" {
  description = "List of ports to forward to backend services. Max is 5. The `ports` or `all_ports` are mutually exclusive."
  type        = list(string)
  default     = ["80"]
}

variable "all_ports" {
  description = "Boolean for all_ports setting on forwarding rule. The `ports` or `all_ports` are mutually exclusive."
  type        = bool
  default     = false
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    check_interval_sec  = optional(number)
    healthy_threshold   = optional(number)
    timeout_sec         = optional(number)
    unhealthy_threshold = optional(number)
    response            = optional(string)
    proxy_header        = optional(string)
    port                = optional(number, 80)
    port_name           = optional(string)
    request             = optional(string)
    request_path        = optional(string)
    host                = optional(string)
    enable_log          = optional(bool, false)
  })
}

variable "source_tags" {
  description = "List of source tags for traffic between the internal load balancer."
  type        = list(string)
}

variable "target_tags" {
  description = "List of target tags for traffic between the internal load balancer."
  type        = list(string)
}

variable "source_ip_ranges" {
  description = "List of source ip ranges for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "source_service_accounts" {
  description = "List of source service accounts for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "target_service_accounts" {
  description = "List of target service accounts for traffic between the internal load balancer."
  type        = list(string)
  default     = null
}

variable "ip_address" {
  description = "IP address of the internal load balancer, if empty one will be assigned. Default is empty."
  type        = string
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "service_label" {
  description = "Service label is used to create internal DNS name"
  default     = null
  type        = string
}

variable "connection_draining_timeout_sec" {
  description = "Time for which instance will be drained"
  default     = null
  type        = number
}

variable "create_backend_firewall" {
  description = "Controls if firewall rules for the backends will be created or not. Health-check firewall rules are controlled separately."
  default     = true
  type        = bool
}

variable "create_health_check_firewall" {
  description = "Controls if firewall rules for the health check will be created or not. If this rule is not present backend healthcheck will fail."
  default     = true
  type        = bool
}

variable "firewall_enable_logging" {
  description = "Controls if firewall rules that are created are to have logging configured. This will be ignored for firewall rules that are not created."
  default     = false
  type        = bool
}

variable "labels" {
  description = "The labels to attach to resources created by this module."
  default     = {}
  type        = map(string)
}

variable "is_mirroring_collector" {
  description = "Indicates whether or not this load balancer can be used as a collector for packet mirroring. This can only be set to true for load balancers that have their loadBalancingScheme set to INTERNAL."
  default     = false
  type        = bool
}
