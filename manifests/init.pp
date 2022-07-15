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

  # XXX The current dsid/rce service binaries are linked against libreadline.so.6, which does not exist in EL8.
  # error while loading shared libraries: libreadline.so.6: cannot open shared object file: No such file or directory
  if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '8') >= 0 {
    file { '/usr/lib64/libreadline.so.6':
      ensure => link,
      owner  => 'root',
      group  => 'root',
      target => 'libreadline.so.7.0',
    }
  }
}
