class picluster {

	$clustersoftware = [ 'corosync', 'pacemaker' ]
	$clusterservices = [ 'corosync' ]

	case $hostname {
		node1:  {
		        $ip = '192.168.1.100'
			$nm = '255.255.255.0'
			$gw = '192.168.1.1'
			}
		node2:	{
			$ip = '192.168.1.101'
			$nm = '255.255.255.0'
			$gw = '192.168.1.1'
			}
		       }
	service
	       { $clusterservices:
			ensure => 'running',
			enable => 'true';
	       }

	package
	       { $clustersoftware:
			ensure => 'installed';
	       }
	
	File 
	 {
		ensure 	=> 'present',
		owner	=> 'root',
		group	=> 'root',
		mode	=> '0644',
	 } 

    	file
         { "/etc/corosync/corosync.conf":
                source  => "puppet:///modules/picluster/etc/corosync/corosync.conf",
		notify  => Service[corosync];
	   "/etc/default/corosync":
                source  => "puppet:///modules/picluster/etc/default/corosync",
                notify  => Service[corosync];
	   "/var/log/cluster":
		ensure  => "directory",
		mode    => "0755";
	   "/etc/network/interfaces":
                content => template("picluster/node.network.erb");
	 }
}
