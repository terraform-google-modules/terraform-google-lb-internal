# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.2.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v4.1.0...v4.2.0) (2021-08-26)


### Features

* enable failover designation for a backend ([#73](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/73)) ([73e89a8](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/73e89a8b795207d0c172e205d591ff6a7595743a))


### Bug Fixes

* Remove timeout_sec from google_compute_region_backend_service ([#70](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/70)) ([e0ac13b](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/e0ac13b5301b11a3e790de9148993d864ec2a816))

## [4.1.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v4.0.0...v4.1.0) (2021-07-16)


### Features

* Enable users to control if firewall rules for health check are created ([#59](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/59)) ([9206a3c](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/9206a3cf7875050de5f1e4cb59ce67631dcd42aa))

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v3.1.0...v4.0.0) (2021-07-09)


### ⚠ BREAKING CHANGES

* Backend service now inherits the same timeout used for health checks, instead of the former hardcoded value of 10 seconds.

### Features

* Update google_compute_region_backend_service timeout to use same timeout as var.health_check ([#55](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/55)) ([e56d959](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/e56d9595a546a7a42ae5a83fc0d9f2c3cdae274b))


### Bug Fixes

* Correct timeout value in tests to match [#55](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/55) ([#57](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/57)) ([cdd6e72](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/cdd6e72ef650a8c096256d64d6410fa19df3f90a))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v3.0.0...v3.1.0) (2021-05-06)


### Features

* Add forwarding_rule id to output ([#51](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/51)) ([c31903d](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/c31903d281c4c62a6f37f73bb36a3d4a065eeb44))

## [3.0.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.4.0...v3.0.0) (2021-04-12)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#48)

### Features

* Add option to enable health check logging ([#49](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/49)) ([547c932](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/547c9320bdf1d9efe5157dd73a09810e4fa272b4))
* add Terraform 0.13 constraint and module attribution ([#48](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/48)) ([aca0c93](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/aca0c939f4c9eedf555e8cace8d4fd13e4ec871f))

## [2.4.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.3.0...v2.4.0) (2021-02-12)


### Features

* Add `var.create_backend_firewall` to conditionally disable backend firewalls ([#46](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/46)) ([43b75c8](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/43b75c83c0f788a86ed3bcc1f2680b3f23d6635f))

## [2.3.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.2.0...v2.3.0) (2021-01-27)


### Features

* Adding `connection_draining_timeout_sec` variable to control backend service ([#42](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/42)) ([a6198e3](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/a6198e31e7155530f762d4078394a8e9d8b76b28))

## [2.2.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.1.0...v2.2.0) (2020-05-27)


### Features

* Allow global access to internal loadbalancers with var.global_access ([#34](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/34)) ([4c0a9cf](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/4c0a9cf7b4677133ac9158cc4192ddf0a0e6d052))
* Allow internal tcp load balancers on all ports with var.all_ports ([#30](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/30)) ([2761445](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/276144531017152ddcba1ca02073bfa1844d39bb))


### Bug Fixes

* Correct link to module in README ([#27](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/27)) ([eb96515](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/eb96515fdd9f8a6adae5bd44c15adb9e1f0e06fd))

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/compare/v2.0.1...v2.1.0) (2020-02-03)


### Features

* add options to use service accounts and ip ranges in addition to tags ([#24](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/issues/24)) ([ff10bae](https://www.github.com/terraform-google-modules/terraform-google-lb-internal/commit/ff10baefbbf6e7e5ee18e534df17d567b65a020f))

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
