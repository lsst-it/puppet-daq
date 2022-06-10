#
# @api private
#
class daq::config {
  assert_private()

  require daq

  file { $daq::env_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/daq.epp"),
  }
}
