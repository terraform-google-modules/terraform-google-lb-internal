# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [[1.1.0](https://github.com/GoogleCloudPlatform/terraform-google-lb-internal/compare/1.0.4...1.1.0)] - 2019-01-11

### Added

* Test kitchen suite and supporting files/docs added to align with
  [terraform-google-modules](https://github.com/terraform-google-modules)
  standards.

### Changed

* `region` added to the subnetwork data source lookup to ensure resources land
  in the correct region. Without this change, in certain cases the
  `google_compute_forwarding_rule` would fail to be placed in the necessary
  subnetwork region.
