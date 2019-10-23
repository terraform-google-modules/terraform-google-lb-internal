/*
 * Copyright 2019 Google Inc.
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

variable "region" {
  type = "string"
}

variable "network" {
  type = "string"
}

variable "zone" {
  type = "string"
}

variable "service_port" {
  type = "string"
}

variable "target_tags" {
  type    = list(string)
  default = []
}

variable "source_tags" {
  type    = list(string)
  default = []
}

variable "subnetwork" {
  type = "string"
}

variable "service_account" {
  type = object({
    email  = string
    scopes = set(string)
  })
}

variable "subnetwork_project" {
  type = "string"
}

variable "project" {
  type = "string"
}

variable "health_check" {
  type = object({
    type                = string
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    health_port         = number
    port_name           = string
    request_path        = string
    host                = string
  })
}
