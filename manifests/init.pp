#
# @summary Installs and configures LSST DAQ software
#
# @param base_path
#   LSST software base install directory.  Default: '/opt/lsst'
#
# @param conf_path
#   Service config (systemd EnvironmentFile) path. Default: '/etc/sysconfig'
#
# @param backingdir
#   Service backing / cache directory. Default: '/var/lib/vrce'
#
# @param interface
#   Network interface services should listen on. Default: `lsst-daq`
#
class daq (
  Stdlib::Absolutepath $base_path  = '/opt/lsst',
  Stdlib::Absolutepath $conf_path  = '/etc/sysconfig',
  Stdlib::Absolutepath $backingdir = '/var/lib/vrce',
  String $interface                = 'lsst-daq',
) {
  $env_file = "${conf_path}/daq"

  ensure_resources('file', {
      $base_path => {
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        backup => false,
      },
  })
}
