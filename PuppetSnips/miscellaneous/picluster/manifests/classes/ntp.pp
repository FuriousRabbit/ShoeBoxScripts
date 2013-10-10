class ntp {
		case $operatingsystem 	{
		centos,redhat: {
				$service_name = 'ntpd'
				$package_name = 'ntp'
				}	
					
			debian:	{
				$service_name = 'ntp'
				$package_name = 'ntp'
				}
					}
	
                	package { 'ntp':
                        ensure => installed,
			name   => $package_name,
				}
	
			service { 'ntp':
   			ensure => running,
			name   => $service_name,
			enable => true,
				}

}
