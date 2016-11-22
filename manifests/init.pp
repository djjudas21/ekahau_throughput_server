# Class: ekahau_throughput_server
# ===========================
#
# Full description of class ekahau_throughput_server here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'ekahau_throughput_server':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class ekahau_throughput_server (
  $url = 'http://www.ekahau.com/userData/ekahau/wifi-design/documents/iperf3-ekahau.zip',
  $tmp = '/tmp',
  $installdir = '/opt/ekahau_throughput_server',
) {
  # Install Java JRE
  class { '::java':
    distribution => 'jre',
  }

  # create install dir
  file { $installdir:
    ensure => directory,
  }

  # fetch zip file
  wget::fetch { 'iperf3-ekahau.zip':
    source      => $url,
    destination => "${installdir}/iperf3-ekahau.zip",
    timeout     => 0,
    verbose     => false,
    notify      => Exec['unzip'],
    require     => File[$installdir],
  }

  # unzip it
  exec { 'unzip':
    command     => 'unzip iperf3-ekahau.zip',
    cwd         => $installdir,
    path        => '/usr/bin',
    refreshonly => true,
  }

  # Configure a systemd unit
  ::systemd::unit_file { 'ekahauiperf.service':
    source  => "puppet:///modules/${module_name}/ekahauiperf.service",
    require => Class['java'],
  }

  # start service
  service { 'ekahauiperf':
    require => Systemd::Unit_file['ekahauiperf'],
  }

  # make firewall exception
  firewall { '100-ekahau-iperf':
    dport  => '5201',
    proto  => ['tcp', 'udp'],
    action => 'accept',
  }

# selinux rules


}
