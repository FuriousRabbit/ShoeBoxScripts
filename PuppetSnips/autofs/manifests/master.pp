# Type: autofs::config
# 
# You must have a master mount configured for every autofs mount
# 
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# If I have two automounts set such as:
#
# autofs::config {
#  'share':
#   mount_name     => 'share',
#   local_dir      => 'files',
#   mount_options  => '-rw,intr,noatime',
#   nfs_server     => 'nfsserver',
#   remote_path    => '/export/servershare',
#
# autofs::config {
#  'share2':
#   mount_name     => 'share2',
#   local_dir      => 'files',
#   mount_options  => '-rw,intr,noatime',
#   nfs_server     => 'nfsserver',
#   remote_path    => '/export/servershare2',
#
# My master autofs configuration would be:
# autofs::master {
#  'masterconfig':
#   auto_master => [ '/share  /etc/auto.share', 
#                    '/share2  /etc/auto.share2' ]  
define autofs::master($auto_master = [])
 {
  include autofs::service
  file {
   "auto.master":
   ensure   => 'file',
   owner    => 'root',
   group    => 'root',
   mode     => '0644',
   path     => "/etc/auto.master",
   content  => template( 'autofs/auto.master.erb' ),
   notify   => Service[autofs];
 }
} 
