#
# @summary Installs and configures LSST DAQ software
#
# @param base_path
#   LSST software base install directory.
#
class daq (
  Stdlib::Absolutepath $base_path = '/opt/lsst',
) {
  $conf_dir = '/etc/lsst'
  $conf_file = "${conf_dir}/daq.conf"

  ensure_resources('file', {
      $base_path => {
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        backup => false,
      },
  })

  file { $conf_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $conf_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
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
