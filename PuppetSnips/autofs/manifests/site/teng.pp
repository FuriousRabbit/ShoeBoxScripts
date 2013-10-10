class autofs::site::teng {
   autofs::client {
   'home':
    mount_name     => 'home',
    client_mount   => [ '*  -rw,intr,noatime  nfs0-teng:/export/SSD/home/&' ],
             }
   autofs::client {
   'opt':
    mount_name     => 'opt',
    client_mount   => [ '/opt  -rw,intr,noatime  nfs0-teng:/export/SSD/software' ],
             }
   autofs::client {
   'data':
    mount_name     => 'data',
    client_mount   => [ 'mril  -fstype=nfs,hard,intr,nodev  nfs0-teng:/export/SAS/mril',
			'mril0  -fstype=nfs,hard,intr,nodev  nfs0-teng:/export/SSD',
			'archive  -fstype=nfs,hard,intr,nodev nfs1-teng:/export/archive', ],
             }
   autofs::client {
   'mirror':
    mount_name     => 'mirror',
    client_mount   => [ 'mril  -fstype=nfs,hard,intr,nodev,ro  nfs2-teng:/export/xyratex' ],
             }
   autofs::client {
   'tesla':
    mount_name     => 'tesla',
    client_mount   => [ "transfer  -fstype=fuse,rw,noatime,allow_other  :sshfs\#root@tesla\:/transfer" ],
             }
   autofs::master {
   'masterconfig':
    auto_master => [ '/home    /etc/auto.home',
                     '/tesla   /etc/auto.tesla',
                     '/-       /etc/auto.opt',
                     '/data    /etc/auto.data',
                     '/mirror  /etc/auto.mirror' ];
             }
}
