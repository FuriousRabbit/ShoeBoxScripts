# Primary Node Configuration
node 'clusternodes' {
	include ntp
	include bashrc
	include software
	include picluster
}

node 'node1', 'node2' inherits clusternodes {
}

node 'serial' {
	include ntp
}
