#version=RHEL6
install
url --url=http://instserver/cobbler/links/CentOS6_3-x86_64/
#cdrom
lang en_US.UTF-8
keyboard us
network --device eth0 --bootproto dhcp
rootpw  --iscrypted $1$qAaBLAHBLAHBLAHENTERHEREilrdIlzzDB0
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512 --enablefingerprint
selinux --disabled
reboot
timezone --utc America/New_York
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
repo --name=customrepo --baseurl=http://customrepo.localdomain

# NOTE CLEARPART NO LONGER WORKS IN CentOS 6.3 -- MUST USE zerombr
#clearpart --all --initlabel --drives=sda
clearpart --all --initlabel
zerombr

part /boot --fstype=ext4 --size=500
part pv.1 --grow --size=1
volgroup vg_primary pv.1
logvol / --fstype=ext4 --name=lv_root --vgname=vg_primary --grow --size=1024
logvol swap --fstype=swap --name=lv_swap --vgname=vg_primary --size=4096

services --enabled=ntpd,sshd

%packages
@additional-devel
@base
@core
@debugging
@basic-desktop
@desktop-debugging
@desktop-platform
@desktop-platform-devel
@development
@directory-client
@eclipse
@emacs
@fonts
@general-desktop
@kde-desktop
@scientific
@office-suite
@graphical-admin-tools
@graphics
@input-methods
@internet-browser
@java-platform
@legacy-x
@network-file-system-client
@performance
@perl-runtime
@print-client
@remote-desktop-clients
@server-platform
@server-platform-devel
@server-policy
@tex
@technical-writing
@x11
gdm
gpm
%end

%post
#NetworkManager in Centos6 conflicts with NIS
chkconfig NetworkManager off
#Install the custom repo
mv /etc/yum.repos.d{,_bak}
mkdir /etc/yum.repos.d
chmod 755 /etc/yum.repos.d
touch /etc/yum.repos.d/customrepo.repo
echo "[customrepo]" > /etc/yum.repos.d/customrepo.repo
echo "name=customrepo" >> /etc/yum.repos.d/customrepo.repo
echo "baseurl=http://customrepo.localdomain" >> /etc/yum.repos.d/customrepo.repo
echo "enabled=1" >> /etc/yum.repos.d/customrepo.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/customrepo.repo
#Fully update the graphic node
yum update -y
#Setup the display environment
touch /etc/sysconfig/desktop
echo "DISPLAYMANAGER=KDE" >> /etc/sysconfig/desktop
echo "DESKTOP=KDE" >> /etc/sysconfig/desktop
sed -i 's/id\:3/id\:5/' /etc/inittab
#Download and install Lab software (no longer used)
#mount -t nfs -o ro,nolock,udp nfs0:/export/SSD/software /mnt
#rsync -az /mnt/ /opt/
#umount /mnt
#Prompt for the nodes hostname
chvt 3
exec < /dev/tty3 > /dev/tty3
echo "Please enter a hostname: "
read hn
sed -i "s/localhost.localdomain/$hn.localdomain/" /etc/sysconfig/network
chvt 1
exec < /dev/tty1 > /dev/tty1
#Configure Puppet
sed -i "13iserver = puppetserver.localdomain" /etc/puppet/puppet.conf
service puppet start
chkconfig puppet on
#Add the software directory to fstab
echo "nfs:/export/SSD/software		/opt	nfs	defaults	0 0" >> /etc/fstab
