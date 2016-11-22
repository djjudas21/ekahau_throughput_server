# ekahau_throughput_server

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations - OS compatibility, etc.](#limitations)
4. [Development - Guide for contributing to the module](#development)

## Overview

This Puppet module installs [Ekahau Throughput Server](http://www.ekahau.com/wifidesign/throughput)
on Linux.

## Usage

There are only two parameters and in most cases you won't need to change them.

* `url`
Specify the URL to the zip file containing Ekahau Throughput Server, supplied by Ekahau.
Defaults to `http://www.ekahau.com/userData/ekahau/wifi-design/documents/iperf3-ekahau.zip`.

* `installdir` 
The directory to extract EKahau Throughput Server into. Defaults to
`/opt/ekahau_throughput_server`.

## Limitations

This module only works on systems that use systemd to manage services. It has been
developed and tested on CentOS 7.

## Development

Pull requests welcome. No guarantees of dev effort from me if the features are
not useful to my employer.

## Release Notes

### `0.1.0`

Initial release with not many configurable options.
