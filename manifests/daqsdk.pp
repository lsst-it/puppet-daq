#
# @summary Installs LSST DAQ SDK software
#
# @param repo_url
#   DAQ SDK Nexus repo
#
# @param version
#   DAQ SDK relase version string
#
class daq::daqsdk (
  Stdlib::HTTPUrl $repo_url = 'https://repo-nexus.lsst.org/nexus/repository/daq/daq-sdk',
  String          $version  = 'R5-V3.2'
) {
  require daq

  $daq_base_path = "${daq::base_path}/daq-sdk"
  $dl_path       = "${daq_base_path}/dl"
  $archive_name  = "${version}.tgz"
  $dl_file       = "${dl_path}/${archive_name}"
  $source        = "${repo_url}/${archive_name}"
  $install_path  = "${daq_base_path}/${version}"

  file { $daq_base_path:
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
    extract_path => $daq_base_path,
    extract      => true,
    source       => $source,
    require      => File[$daq_base_path],
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

  file { "${daq_base_path}/current":
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => $version,
  }
}
