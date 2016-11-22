# Deploy Ekahau Throughput Server on Linux
class ekahau_throughput_server (
  $url = 'http://www.ekahau.com/userData/ekahau/wifi-design/documents/iperf3-ekahau.zip',
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
    ensure  => 'running',
    enable  => 'true',
    require => Systemd::Unit_file['ekahauiperf.service'],
  }

  # make firewall exception
  firewall { '100-ekahau-iperf':
    dport  => '5201',
    proto  => ['tcp', 'udp'],
    action => 'accept',
  }
}
