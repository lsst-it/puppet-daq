#
# @summary Installs LSST DAQ SDK software
#
# @param repo_url
#   DAQ SDK Nexus repo
#
# @param version
#   DAQ SDK relase version string
#
# @param purge
#   If true, purge unmanaged files under the install path.
#
class daq::daqsdk (
  Stdlib::HTTPUrl $repo_url = 'https://repo-nexus.lsst.org/nexus/repository/daq/daq-sdk',
  String          $version  = 'R5-V3.2',
  Boolean         $purge    = false,
) {
  require daq

  $base_path    = "${daq::base_path}/daq-sdk"
  $dl_path      = "${base_path}/dl"
  $archive_name = "${version}.tgz"
  $dl_file      = "${dl_path}/${archive_name}"
  $source       = "${repo_url}/${archive_name}"
  $install_path = "${base_path}/${version}"
  $current_path = "${base_path}/current"

  # Purge unmanaged versions.  Currently, only one version may be installed at
  # a time.  The $dl_path file resource should protect previously downloaded
  # artifacts from being purged.
  file { $base_path:
    ensure    => directory,
    owner     => 'root',
    group     => 'root',
    mode      => '0755',
    force     => $purge,
    purge     => $purge,
    recurse   => $purge,
    max_files => 10000,
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
    extract_path => $base_path,
    extract      => true,
    source       => $source,
    require      => File[$base_path],
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

  file { $current_path:
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    target  => $version,
    replace => false,
  }
}
