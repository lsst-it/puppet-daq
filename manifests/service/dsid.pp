#
# @summary Manage DAQ DSID service
#
class daq::service::dsid {
  require daq::daqsdk
  require daq::service::config

  $conf = {
    env_file     => $daq::env_file,
    current_path => $daq::daqsdk::current_path,
  }

  systemd::unit_file { 'dsid.service':
    content => epp("${module_name}/dsid.service.epp", $conf),
  }
  ~> service { 'dsid':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$daq::env_file],
  }
}
