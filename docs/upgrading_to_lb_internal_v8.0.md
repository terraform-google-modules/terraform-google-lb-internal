# Upgrading to v8.0

This version introduces breaking changes to align the module with Google's **Application Design Center (ADC)** compliance standards.

## Breaking Changes

### Variable Rename: `project` to `project_id`

To maintain consistency across all Google Cloud blueprints and modules, the `project` input variable has been renamed to `project_id`. This change is required for ADC compliance.

#### Before
```hcl
module "gce-ilb" {
  source  = "terraform-google-modules/lb-internal/google"
  version = "~> 7.0"
  project = "my-project-id"
  # ...
}
After
module "gce-ilb" {
  source     = "terraform-google-modules/lb-internal/google"
  version    = "~> 8.0"
  project_id = "my-project-id"
  # ...
}