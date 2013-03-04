class software {
	$software = [ 'vim', 'dnsutils' ]

	package
	       { $software:
			ensure => 'installed';
	       }
}
