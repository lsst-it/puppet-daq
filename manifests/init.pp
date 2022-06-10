#
# @summary Installs and configures LSST DAQ software
#
# @param base_path
#   LSST software base install directory.
#
# @param conf_path
#   Service config (systemd EnvironmentFile) path.
#
# @param interface
#   Network interface services should listen on. Default: `lsst-daq`
#
class daq (
  Stdlib::Absolutepath $base_path = '/opt/lsst',
  Stdlib::Absolutepath $conf_path = '/etc/sysconfig',
  String $interface               = 'lsst-daq',
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
