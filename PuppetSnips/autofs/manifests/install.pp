# Class: autofs::install
#
# This class ensures that the distro-appropriate autofs package is installed
# 
# Parameters:
# 
# Actions:
# 
# Requires:
# 
# Sample Usage:
#   This class should not be used directly under normal circumstances
#   Instead, use the *autofs* class.
class autofs::install {
  case $operatingsystem{
    redhat, centos: {
    $package_name  = ['nfs-utils', 'autofs']
    $config_file   = "/etc/sysconfig/autofs"
    }
    ubuntu, debian: {
    $package_name  = ['nfs-common', 'autofs']
    $config_file   = "/etc/default/autofs"
    }
 }
  package {
   'autofs':
    name    => $package_name,
    ensure  => installed;
  }
  file {
   'autofs_config':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => $config_file,
    source  => "puppet:///modules/autofs/autofs",
    notify  => Service[autofs];
   }
}
