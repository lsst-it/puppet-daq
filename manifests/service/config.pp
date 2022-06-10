#
# @api private
#
class daq::service::config {
  assert_private()

  require daq

  $env_conf = {
    interface  => $daq::interface,
  }

  file { $daq::env_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/daq.epp", $env_conf),
  }
}
