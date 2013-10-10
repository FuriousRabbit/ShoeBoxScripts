class bashrc {
    file { '/root/.bashrc':
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///files/bashrc',
    	 }
}
