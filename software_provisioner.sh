# Provisioner for software

# need to globally disable some packages, they break the install
# in /etc/yum.conf:
# exclude=cloud-init,git*,ganglia*
cp /home/centos/yum/yum.conf /etc/

mkdir /home/centos/src/
cd /home/centos/src/

yum update -y

wget "http://downloads.sourceforge.net/project/modules/Modules/modules-3.2.10/modules-3.2.10.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmodules%2Ffiles%2F&ts=1433366084&use_mirror=iweb" -O modules-3.2.10.tar.gz
tar xzf modules-3.2.10.tar.gz
cd modules-3.2.10/
./configure && make && make install && make clean
cd -

## For Sailfish
# This needs the module file at modulefiles/Sailfish/0.6.3
cd /opt/
wget "https://github.com/kingsfordgroup/sailfish/releases/download/v0.6.3/Sailfish-0.6.3-Linux_x86-64.tar.gz" -O Sailfish-0.6.3-Linux_x86-64.tar.gz
tar -xzf Sailfish-0.6.3-Linux_x86-64.tar.gz
cd -

# Copy pre-made module files - these were moved to the instance at the beginning
# of the provision
cp -R /home/centos/modulefiles/* /usr/share/Modules/modulefiles/

# OpenBlas
mkdir /home/centos/src/OpenBlas
cd /home/centos/src/OpenBlas
wget http://github.com/xianyi/OpenBLAS/archive/v0.2.15.tar.gz
tar xzf v0.2.15.tar.gz
cd OpenBLAS-0.2.15/
make BINARY=64 FC=gfortran USE_THREAD=1 && make install && make clean

cd /home/centos/src

# Newer version of git
yum remove -y git
wget https://github.com/git/git/archive/v2.7.1.tar.gz
tar xzf v2.7.1.tar.gz
cd git-2.7.1
make configure
./configure --prefix=/usr --with-curl=/usr/bin/curl
make all && make install && make clean
