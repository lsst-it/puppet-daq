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

  if fact('os.family') == 'RedHat' {
    # XXX daqsdk < V10 is linked against libreadline.so.6, which does not
    # exist in EL8+. While daqsdk >= V10 is linked against libreadline.so.7.
    $os_readline = fact('os.release.major') ? {
      '8'     => 'libreadline.so.7.0',
      '9'     => 'libreadline.so.8.1',
      default => 'libreadline.so.8.1',
    }

    $legacy_readline_versions = fact('os.release.major') ? {
      # EL8 natively has libreadline.so.7
      '8'     => ['6'],
      # EL9+
      '9'     => ['6', '7'],
      default => ['6', '7'],
    }

    $legacy_readline_versions.each |$v| {
      file { "/usr/lib64/libreadline.so.${v}":
        ensure => link,
        owner  => 'root',
        group  => 'root',
        target => $os_readline,
      }
    }
  }
}
