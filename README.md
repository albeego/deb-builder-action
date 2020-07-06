# GitHub Action for deploying packages to a Signed APT repository

Build a .deb package for deploying to debian or derivatives like ubuntu. Compatible with systemd unit installation as part of the produced package

## Inputs

### `execution_path`:
**Required** Sub directory in which to execute the action defaults to the repository root
### `package_name`
**Required** The name of the package to build

## Usage

To build a deb package, you will need to include a debian folder in the `execution_path` directory of your project. This should contain the following files:

### `control`
There is a lot of information that is stored in the control file describing the package, you can see the documentation here: https://www.debian.org/doc/debian-policy/ch-controlfields.html As a starting point:
```shell script
Source: my-awesome-package
Section: misc
Priority: optional
Maintainer: Me <me@mydomain.com>
Standards-Version: 3.9.7

Package: my-awesome-package
Depends:
Architecture: amd64
Essential: no
Description: Does awesome things to your computer
``` 
### `compat`
This file states the debian version number your package is compatible with:
```shell script
9
``` 
### `my-awesome-package.install`
this file controls what is copied from the build in to the deb package, it is formatted as `source target` lines relative to itself:
```shell script
../../target/release/my_awesome_service usr/bin
```
### `source/format`
This file specifies whether the package applies to debian solely or is useful for other distributions. State it as:
```shell script
3.0 (native)
``` 
This is debian only
### SystemD unit installations
Include your unit file in the debian directory with the rest if the files and add a `rules` file with the following contents
```shell script
#!/usr/bin/make -f

PKGDIR=debian/tmp

%:
	dh $@ --with systemd

override_dh_installinit:
	dh_systemd_enable -pmy-awesome-package --name=my-awesome-package my-awesome-package.service
	dh_installinit -pmy-awesome-package --no-start --noscripts
	dh_systemd_start -pmy-awesome-package --no-restart-on-upgrade

override_dh_systemd_start:
	echo "Not running dh_systemd_start"

override_dh_strip:
	echo "Not running dh_strip"
```
Make sure you replace my-awesome-package with your package name

### Sample implementation
```yaml
name: Build a deb package

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Build deb package
      uses:  albeego/deb-builder-action@master
      with:
        execution_path: sumbodule/build-directory
        package_name: my-awesome-package
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE-MIT.txt).
