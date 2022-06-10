#
# @api private
#
class daq::service::config {
  assert_private()

  require daq
  require daq::daqsdk

  file { $daq::env_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/daq.epp", { current_path => $daq::daqsdk::current_path }),
  }
}
