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

module "instance_template1" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/nginx_upstream.sh.tpl", { UPSTREAM = module.gce-ilb.ip_address })
  tags               = ["allow-group1"]
}

module "instance_template2" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/gceme.sh.tpl", { PROXY_PATH = "" })
  tags               = ["allow-group2"]
}

module "instance_template3" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/gceme.sh.tpl", { PROXY_PATH = "" })
  tags               = ["allow-group3"]
}

module "mig1" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork_project = var.subnetwork_project
  region             = var.region
  target_pools       = [module.gce-lb-fr.target_pool]
  instance_template  = module.instance_template1.self_link
  hostname           = "mig1"
  named_ports        = local.named_ports
}

module "mig2" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork_project = var.subnetwork_project
  region             = var.region
  hostname           = "mig2"
  instance_template  = module.instance_template2.self_link
  named_ports        = local.named_ports
}

module "mig3" {
  source             = "terraform-google-modules/vm/google//modules/mig"
  version            = "~> 2.1.0"
  project_id         = var.project
  subnetwork_project = var.subnetwork_project
  region             = var.region
  hostname           = "mig3"
  instance_template  = module.instance_template3.self_link
  named_ports        = local.named_ports
}
