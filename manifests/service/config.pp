#
# @api private
#
class daq::service::config {
  assert_private()

  require daq

  $env_conf = {
    interface  => $daq::interface,
    backingdir => $daq::backingdir,
  }

  file { $daq::backingdir:
    ensure => directory,
    owner  => 'root',
    group  => 'daq',
    mode   => '0775',
  }

  file { $daq::env_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/daq.epp", $env_conf),
  }
}
