# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.7] - 2026-09-30

### Fixed

- Docker check uses `command -v` instead of parsing `which` output through a variable named `test`

## [0.1.6] - 2026-09-30

### Fixed

- Script exits with a clear message if the docker daemon is not running or not accessible, instead of attempting a build

## [0.1.5] - 2026-09-30

### Fixed

- `--help`, `-h`, `--version` and `-V` are recognised as the first argument rather than only as the sole argument

## [0.1.4] - 2026-09-30

### Added

- Current directory is mounted at `/work` (the container working directory), so racadm subcommands that read or write local files can use relative paths

## [0.1.3] - 2026-09-30

### Fixed

- Image existence check uses `docker image inspect` instead of grepping `docker images`, so similarly named images no longer trigger a rebuild on every run

## [0.1.2] - 2026-09-30

### Fixed

- Arguments are now passed to racadm directly (`"$@"`) instead of being re-parsed by `bash -c`, so passwords and values containing spaces, quotes or shell characters work

## [0.1.1] - 2026-09-30

### Fixed

- Containers are removed after each run (`docker run --rm`) instead of accumulating

## [0.1.0] - 2026-09-30

### Fixed

- Removed the unneeded `docker-compose` requirement, as only `docker build` is used

## [0.0.9] - 2026-09-30

### Fixed

- Error paths (docker missing, running inside docker) now exit with status 1 instead of 0

## [0.0.8] - 2026-09-30

### Fixed

- README symlink example used `ls -s` instead of `ln -s`

### Changed

- License changed from CC BY to CC BY-NC-SA 4.0

## [0.0.7] - 2023-09-30

### Removed

- Interactive flag, so the script can be run from another script that requires a TTY

## [0.0.6] - 2023-09-30

### Added

- Help switch

## [0.0.5] - 2023-09-30

### Added

- Version switch

## [0.0.4] - 2023-09-30

### Changed

- Code cleanup

## [0.0.3] - 2023-09-30

### Added

- Initial working version

## [0.0.2] - 2023-09-29

### Added

- Working docker compose

## [0.0.1] - 2023-09-29

### Added

- Initial version
