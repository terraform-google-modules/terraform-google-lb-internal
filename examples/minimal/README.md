# Internal TCP/UDP Load Balancer Example

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/GoogleCloudPlatform/terraform-google-lb-internal&working_dir=examples/minimal&page=shell&tutorial=README.md)

This example creates a regional internal forwarding rule to forward traffic to
backends in the us-central1 region.

You can add backends to the load balancer's backend service by using
the [gcloud compute backend-services
add-backend](https://cloud.google.com/sdk/gcloud/reference/compute/backend-services/add-backend)
command.

## Change to the example directory

```
[[ `basename $PWD` != minimal ]] && cd examples/minimal
```

## Install Terraform

1. Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

## Set up the environment

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```
PROJECT=YOUR_PROJECT
```

```
gcloud config set project ${PROJECT}
```

2. Configure the environment for Terraform:

```
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Run Terraform

```
terraform init
terraform apply
```

## Test load balancing

1. Add backends to the backend service.

   The backends must be in the same region and VPC network as the forwarding rule.

2. Create a client VM in the same region and VPC network.

3. SSH to the client VM and then run:

   ```
   curl http://(IP address of the forwarding rule)
   ```

## Cleanup

1. Remove all resources created by terraform:

```
terraform destroy
```
