#
# @summary Manage DAQ RCE service
#
class daq::service::rce {
  require daq::service::config

  systemd::unit_file { 'rce.service':
    content => epp("${module_name}/rce.service.epp", { env_file => $daq::env_file }),
  }
  ~> service { 'rce':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$daq::env_file],
  }
}
