#
# @summary Installs LSST RPT SDK software
#
# @param repo_url
#   RPT SDK Nexus repo
#
# @param version
#   RPT SDK relase version string
#
class daq::rptsdk (
  Stdlib::HTTPUrl $repo_url = 'https://repo-nexus.lsst.org/nexus/repository/daq/rpt-sdk',
  String          $version  = 'V3.5.3'
) {
  require daq

  $rpt_base_path = "${daq::base_path}/rpt-sdk"
  $dl_path       = "${rpt_base_path}/dl"
  $archive_name  = "rce-sdk-${version}.tar.gz"
  $dl_file       = "${dl_path}/${archive_name}"
  $source        = "${repo_url}/${archive_name}"
  $install_path  = "${rpt_base_path}/${version}"

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

  archive { $dl_file:
    ensure       => present,
    cleanup      => false,
    creates      => $install_path,
    extract_path => $rpt_base_path,
    extract      => true,
    source       => $source,
    require      => File[$rpt_base_path],
  }
  ~> file { $dl_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # chown untar dir
  file { $install_path:
    owner     => 'root',
    group     => 'root',
    recurse   => true,
    max_files => 10000,
    require   => Archive[$dl_file],
  }

  file { "${rpt_base_path}/current":
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $version,
  }
}
