# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add more params to tcp healthcheck. [#23](https://github.com/terraform-google-modules/terraform-google-lb-internal/pull/23)

## [2.0.1] - 2019-11-22

### Fixed

- the `region` variable is passed to the `google_compute_subnetwork` data source. [#18]

## [2.0.0] - 2019-11-05

### Added

- `subnetwork` variable.
- Support for HTTP health checks. [#3]
- Support for Terraform 0.12. [#10]

### Changed

- Health checks support more parameters. [#10]

### Removed

- Support for Terraform 0.11. [#10]

## [1.0.4] - 2017-11-08

## [1.0.3] - 2017-11-01

## [1.0.2] - 2017-09-18

## [1.0.1] - 2017-09-12

## [1.0.0] - 2017-08-28

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.0.1...HEAD
[2.0.1]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/1.0.4...v2.0.0
[1.0.4]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/1.0.3...1.0.4
[1.0.3]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/1.0.2...1.0.3
[1.0.2]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/terraform-google-modules/terraform-google-lb-internal/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-lb-internal/releases/tag/1.0.0

[#18]: https://github.com/terraform-google-modules/terraform-google-lb-internal/issues/18
[#10]: https://github.com/terraform-google-modules/terraform-google-lb-internal/issues/10
[#3]: https://github.com/terraform-google-modules/terraform-google-lb-internal/issues/3
