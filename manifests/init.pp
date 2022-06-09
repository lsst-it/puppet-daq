#
# @summary Installs and configures LSST DAQ software
#
class daq {
  $conf_dir = '/etc/lsst'
  $conf_file = "${conf_dir}/daq.conf"

  file { $conf_dir:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { $conf_file:
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => epp("${module_name}/daq.conf.epp"),
  }

  systemd::unit_file { 'dsid.service':
    content => epp("${module_name}/dsid.service.epp"),
  }
  ~> service { 'dsid':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$conf_file],
  }

  systemd::unit_file { 'rce.service':
    content => epp("${module_name}/rce.service.epp"),
  }
  ~> service { 'rce':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$conf_file],
  }
}
