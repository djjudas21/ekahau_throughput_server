# Deploy Ekahau Throughput Server on Linux
class ekahau_throughput_server (
  $url = 'http://ekahau.demo.site/wp-content/uploads/2017/02/iperf3-ekahau.zip',
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
    notify      => Exec['unzip-ekahau'],
    require     => File[$installdir],
  }

  # unzip it
  exec { 'unzip-ekahau':
    command     => 'unzip iperf3-ekahau.zip',
    cwd         => $installdir,
    path        => '/usr/bin',
    refreshonly => true,
  }

  # Configure a systemd unit
  ::systemd::unit_file { 'ekahauiperf.service':
    source  => "puppet:///modules/${module_name}/ekahauiperf.service",
  }

  # start service
  service { 'ekahauiperf':
    ensure  => 'running',
    enable  => true,
    require => [
      Systemd::Unit_file['ekahauiperf.service'],
      Exec['unzip-ekahau'],
      Class['java'],
    ],
  }

  # make firewall exception
  firewall { '100-ekahau-iperf-tcp':
    dport  => '5201',
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '100-ekahau-iperf-udp':
    dport  => '5201',
    proto  => 'udp',
    action => 'accept',
  }
}
