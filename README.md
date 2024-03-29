# setup

> Setup scripts for my environments

[![Arch Linux](https://github.com/masnagam/setup/actions/workflows/arch.yml/badge.svg)](https://github.com/masnagam/setup/actions/workflows/arch.yml)
[![Debian](https://github.com/masnagam/setup/actions/workflows/debian.yml/badge.svg)](https://github.com/masnagam/setup/actions/workflows/debian.yml)
[![macOS](https://github.com/masnagam/setup/actions/workflows/macos.yml/badge.svg)](https://github.com/masnagam/setup/actions/workflows/macos.yml)

This projects contains scripts and files which are used for preparing my environments.

Some of the scripts may also be useful in your environment.

## Usage

Debian:

```shell
sudo apt-get install -y --no-install-recommends ca-certificates curl
curl -fsSL https://raw.githubusercontent.com/masnagam/setup/main/debian.sh | sh -s -- -h
```

Arch Linux:

```shell
sudo pacman -S --noconfirm base-devel ca-certificates curl
curl -fsSL https://raw.githubusercontent.com/masnagam/setup/main/arch.sh | sh -s -- -h
```

Run a script directly:

```shell
# Required variables vary depending on the script to be executed.
export SETUP_TARGET=debian
export SETUP_BASEURL=https://raw.githubusercontent.com/masnagam/setup/main
curl -fsSL $SETUP_BASEURL/scripts/bash.sh | sh -s
```

After setup, you can use `$HOME/bin/run-setup-script` instead.

Fetch a file directly:

```
curl -fsSL https://raw.githubusercontent.com/masnagam/setup/main/files/emacs.init.el \
  >$HOME/.emacs.d/init.el
```

After setup, you can use `$HOME/bin/fetch-setup-file` instead.

## How to test

Install [Vagrant] before testing:

```shell
# run integration tests for each target
make test

# run debian.sh for integration tests
make test-debian

# run scripts/bash.sh on Arch Linux
make test-scripts-bash TARGET=arch
```

## License

MIT

[Vagrant]: https://www.vagrantup.com/
