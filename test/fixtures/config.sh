#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function copy_credentials_to_root() {
  if [ -z "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
    echo "No environment variable set for GOOGLE_APPLICATION_CREDENTIALS. Set this before running again. Exiting."
    exit 1
  fi
  cp "${GOOGLE_APPLICATION_CREDENTIALS}" "$(pwd)/credentials.json"
}

# Find a random region using a gcloud command. Set it in terraform.tfvars in any fixtures if not present
function set_region() {
  REGION_LIST=$(gcloud compute regions list --format="value(name)")
  FIXTURE_DIRS=$(find test/fixtures -type d -depth 1)
  for dir in ${FIXTURE_DIRS}; do
    TF_VARS_FILE="${dir}/terraform.tfvars"
    REGION_INDEX=$(echo ${RANDOM} % 18 + 1 | bc)
    REGION=$(echo "${REGION_LIST}" | head -n"${REGION_INDEX}" | tail -n1)
    if ! grep 'region =' "${TF_VARS_FILE}" -q; then
      echo "region not set in ${TF_VARS_FILE}. Setting to ${REGION}."
      echo "region = \"${REGION}\"" >>"${TF_VARS_FILE}"
    fi
  done
}

function set_project_name() {
  FIXTURE_DIRS=$(find test/fixtures -type d -depth 1)
  for dir in ${FIXTURE_DIRS}; do
    TF_VARS_FILE="${dir}/terraform.tfvars"
    if ! grep 'project_name =' "${TF_VARS_FILE}" -q; then
      DEFAULT_PROJECT_NAME=$(jq '.project_id' <"${GOOGLE_APPLICATION_CREDENTIALS}")
      echo "project_name = ${DEFAULT_PROJECT_NAME}" >>"${TF_VARS_FILE}"
    fi
  done
}

copy_credentials_to_root
set_project_name
set_region
