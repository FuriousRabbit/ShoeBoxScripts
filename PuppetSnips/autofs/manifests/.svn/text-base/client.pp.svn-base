# Type: autofs::client
# 
# This is the primary configuration for the autofs module
# 
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# autofs::client {
#  'share':
#   mount_name     => 'stuff',
#   local_dir      => 'files',
#   mount_options  => '-rw,intr,noatime',
#   nfs_server     => 'nfsserver',
#   remote_path    => '/export/servershare',
define autofs::client(
  $mount_name = 'share', $client_mount = [],
  $ensure = 'present', $mode = '0644')
  {
  include autofs::service
  case $ensure {
   "present": { $real_ensure = file }
    "absent": { $real_ensure = absent }
     default: { fail("Invalid value '${ensure}' used for ensure") }
  }
  file {
   "auto${title}":
    ensure  => $real_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => $mode,
    path    => "/etc/auto.$mount_name",
    content => template( 'autofs/auto.mount.erb' ),
    notify  => Service[autofs];
  }
}
