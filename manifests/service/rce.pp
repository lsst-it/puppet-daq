#
# @summary Manage DAQ RCE service
#
class daq::service::rce {
  require daq::daqsdk
  require daq::service::config

  $conf = {
    env_file     => $daq::env_file,
    current_path => $daq::daqsdk::current_path,
  }

  systemd::unit_file { 'rce.service':
    content => epp("${module_name}/rce.service.epp", $conf),
  }
  ~> service { 'rce':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$daq::env_file],
  }
}
