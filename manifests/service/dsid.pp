#
# @summary Manage DAQ DSID service
#
class daq::service::dsid {
  require daq::config
  require daq::daqsdk

  systemd::unit_file { 'dsid.service':
    content => epp("${module_name}/dsid.service.epp", { env_file => $daq::env_file }),
  }
  ~> service { 'dsid':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$daq::env_file],
  }
}
