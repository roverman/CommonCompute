# Provisioner for software

# need to globally disable some packages, they break the install
# in /etc/yum.conf:
# exclude=cloud-init,git*,ganglia*
cp /home/ec2-user/yum/yum.conf /etc/

mkdir /root/src/
cd /root/src/

# Get rid of this stuff - might be removed in subsequent cfncluster releases
yum remove -y zfs-release.noarch libnvpair1.x86_64 libuutil1.x86_64 libzfs2.x86_64 libzfs2-devel.x86_64 libzpool2.x86_64 lustre.x86_64 lustre-debuginfo.x86_64 lustre-dkms.noarch lustre-osd-ldiskfs.x86_64 lustre-osd-zfs.x86_64 lustre-source.x86_64 lustre-tests.x86_64 spl.x86_64 spl-debuginfo.x86_64 spl-dkms.noarch zfs.x86_64 zfs-debuginfo.x86_64 zfs-devel.x86_64 zfs-dkms.noarch zfs-dracut.x86_64 zfs-test.x86_64

yum update -y

wget "http://downloads.sourceforge.net/project/modules/Modules/modules-3.2.10/modules-3.2.10.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmodules%2Ffiles%2F&ts=1433366084&use_mirror=iweb" -O modules-3.2.10.tar.gz
tar xzf modules-3.2.10.tar.gz
cd modules-3.2.10/
./configure && make && make install
cd -

## For Sailfish
# This needs the module file at modulefiles/Sailfish/0.6.3
cd /opt/
wget "https://github.com/kingsfordgroup/sailfish/releases/download/v0.6.3/Sailfish-0.6.3-Linux_x86-64.tar.gz" -O Sailfish-0.6.3-Linux_x86-64.tar.gz
tar -xzf Sailfish-0.6.3-Linux_x86-64.tar.gz
cd -

# Copy pre-made module files - these were moved to the instance at the beginning
# of the provision
cp -R /home/ec2-user/modulefiles/* /usr/share/Modules/modulefiles/

# OpenBlas
mkdir /root/src/OpenBlas
cd /root/src/OpenBlas
wget http://github.com/xianyi/OpenBLAS/archive/v0.2.15.tar.gz
tar xzf v0.2.15.tar.gz
cd OpenBLAS-0.2.15/
make BINARY=64 FC=gfortran USE_THREAD=1 && make install

cd /root/src

# Newer version of git
yum remove -y git
wget https://github.com/git/git/archive/v2.4.5.tar.gz
tar xzf v2.4.5.tar.gz
cd git-2.4.5
make prefix=/usr all && make prefix=/usr install
