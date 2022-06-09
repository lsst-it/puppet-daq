#
# @summary Installs and configures LSST DAQ software
#
# @param base_path
#   LSST software base install directory.
#
# @param rpt_repo_url
#   RPT Nexus repo
#
# @param rpt_version
#   RPT relase version string
#
class daq (
  Stdlib::Absolutepath $base_path = '/opt/lsst',
  Stdlib::HTTPUrl      $rpt_repo_url  = 'https://repo-nexus.lsst.org/nexus/repository/daq/rpt-sdk',
  String               $rpt_version   = 'V3.5.3'
) {
  $conf_dir = '/etc/lsst'
  $conf_file = "${conf_dir}/daq.conf"

  $rpt_base_path = "${base_path}/rpt-sdk"
  $dl_path       = "${rpt_base_path}/dl"
  $archive_file  = "rce-sdk-${rpt_version}.tar.gz"
  $source        = "${rpt_repo_url}/${archive_file}"

  ensure_resources('file', {
      $base_path => {
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        backup => false,
      },
  })

  file { $rpt_base_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    #recurse => true,
    #purge   => true,
    #force   => true,
  }

  file { $dl_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  archive { "${dl_path}/${archive_file}":
    ensure       => present,
    cleanup      => false,
    creates      => "${rpt_base_path}/${rpt_version}",
    extract_path => $rpt_base_path,
    extract      => true,
    source       => $source,
    require      => File[$rpt_base_path],
  }
  ~> file { "${rpt_base_path}/${rpt_version}":
    owner     => 'root',
    group     => 'root',
    recurse   => true,
    max_files => 10000,
  }

  file { "${rpt_base_path}/current":
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => "${rpt_base_path}/${rpt_version}",
  }

  file { $conf_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $conf_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/daq.conf.epp"),
  }

  systemd::unit_file { 'dsid.service':
    content => epp("${module_name}/dsid.service.epp"),
  }
  ~> service { 'dsid':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$conf_file],
  }

  systemd::unit_file { 'rce.service':
    content => epp("${module_name}/rce.service.epp"),
  }
  ~> service { 'rce':
    ensure    => 'running',
    enable    => true,
    subscribe => File[$conf_file],
  }
}
