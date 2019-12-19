# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'json'

project_id = attribute('project_id')
region = attribute('region')
random_suffix = attribute('random_suffix')
resource_name_prefix = "ilb-minimal-#{random_suffix}"
gcloud_args = "--format json --project #{project_id}"

control 'minimal' do
  title 'A minimal example of running an internal load balancer.'
  describe google_compute_firewall(project: project_id, name: "#{resource_name_prefix}-ilb-fw") do
    it { should allow_source_tags_only ['source-tag-foo'] }
    it { should allow_target_tags_only ['target-tag-bar'] }
    it { should allow_port_protocol('8080', 'tcp') }
    its('allowed_ssh?') { should be false }
    its('allowed_http?') { should be false }
    its('direction') { should eq 'INGRESS' }
    it { should_not allow_ip_ranges ['0.0.0.0/0'] }
  end

  describe google_compute_firewall(project: project_id, name: "#{resource_name_prefix}-hc") do
    it { should_not allow_port_protocol('22', 'tcp') }
    it { should allow_port_protocol('8081', 'tcp') }
    its('direction') { should eq 'INGRESS' }
    its('allowed_ssh?') { should be false }
    its('allowed_http?') { should be false }
    it { should_not allow_ip_ranges ['0.0.0.0/0'] }
    it { should allow_ip_ranges_only ['130.211.0.0/22', '35.191.0.0/16'] }
  end

  describe google_compute_forwarding_rule(project: project_id, region: region, name: "#{resource_name_prefix}") do
    its('load_balancing_scheme') { should eq 'INTERNAL' }
    its('network') { should match "#{resource_name_prefix}" }
    its('backend_service') { should match "#{resource_name_prefix}" }
  end

  health_checks = JSON.parse(`gcloud compute health-checks list --filter="name:( #{resource_name_prefix}-hc )" #{gcloud_args}`)
  describe 'The health check' do
    it 'exists and there is only 1' do
      expect(health_checks.length).to eq(1)
    end
    it 'is listening on 8081' do
      expect(health_checks[0]['httpHealthCheck']['port']).to eq(8081)
    end
    it 'is of type HTTP' do
      expect(health_checks[0]['type']).to eq('HTTP')
    end
  end

  backend_services = JSON.parse(`gcloud compute backend-services list --filter="name:( #{resource_name_prefix} )" #{gcloud_args}`)
  describe 'The backend service' do
    it 'exists and there is only 1' do
      expect(backend_services.length).to eq(1)
    end
    it 'has exactly one health check' do
      expect(backend_services[0]['healthChecks'].length).to eq(1)
    end
    it 'is using the healthcheck created by this module' do
      expect(backend_services[0]['healthChecks'][0]).to end_with "#{resource_name_prefix}-hc-http"
    end

    it 'has a timeout length of 10 seconds' do
      expect(backend_services[0]['timeoutSec']).to eq(10)
    end
  end
end
