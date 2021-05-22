# setup

> Setup scripts for my environments

[![Debian](https://github.com/masnagam/setup/actions/workflows/debian.yml/badge.svg)](https://github.com/masnagam/setup/actions/workflows/debian.yml)

This projects contains scripts and files which are used for preparing my environments.

Some of the scripts may also be useful in your environment.

## Usage

Debian:

```shell
curl -fsSL https://raw.githubusercontent.com/masnagam/setup/main/debian.sh | sh -s -- -h
```

## How to test

Install [Vagrant] before testing:

```shell
# run integration tests for each target
make test

# run debian.sh for integration tests
make test-debian

# run scripts/bash.sh on debain
make test-debian-scripts-bash
```

## License

MIT

[Vagrant]: https://www.vagrantup.com/
