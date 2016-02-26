#!/bin/bash -x

# Need this for module loading
source /etc/profile.d/modules.sh

cd /home/centos/src/

yum makecache
yum install -y ed less wget
yum install -y python python-devel

# Install newer version of python 2
# Will require a module file
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
tar xzf Python-2.7.11.tgz
cd Python-2.7.11
mkdir /opt/Python-2.7.11/
./configure --prefix=/opt/Python-2.7.11/ --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall && make clean
cd ..

ln -s /opt/Python-2.7.11/bin/python2.7 /opt/Python-2.7.11/bin/python

# Copy pre-made module files - these were moved to the instance at the beginning
# of the provision
cp -R /home/centos/modulefiles/* /usr/share/Modules/modulefiles/

# Requires copying of the module file at beginning of provisioning
module load python/2.7.11

curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | /opt/Python-2.7.11/bin/python2.7

easy_install pip
pip2.7 install --upgrade pip

pip2.7 install cython

# Install numpy, using openblas
cd /home/centos/src
pip2.7 install -d /home/centos/src numpy
tar xzf numpy-*.tar.gz
cd numpy-*

# # files uploaded by file provisioner
# # configuration for openblas, which should be at /opt/OpenBLAS/
cp /home/centos/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install

cd /home/centos/src
rm -rf numpy-*

# Install scipy, using openblas
cd /home/centos/src
pip2.7 install -d /home/centos/src scipy
tar xzf scipy-*.tar.gz
cd scipy-*

# # files uploaded by file provisioner
# # configuration for openblas, which should be at /opt/OpenBLAS/
cp /home/centos/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install

cd /home/centos/src
rm -rf scipy*

## Need this to get the lib; should be in the python modulefile
# export LD_LIBRARY_PATH=/opt/OpenBLAS/lib:$LD_LIBRARY_PATH

## For Synapse Python client, fixes an InsecurePlatformWarning
module unload python
# yum -y remove pyOpenSSL
yum -y install libffi-devel openssl-devel

module load python/2.7.11
pip3.5 install -r /home/centos/python_requirements.txt
module unload python/2.7.11

# Install python 3
# Can use a module file
wget https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tgz
tar xzf Python-3.5.1.tgz
cd Python-3.5.1
mkdir /opt/Python-3.5.1/
./configure --prefix=/opt/Python-3.5.1/ --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
    make && make altinstall

cd ..

ln -s /opt/Python-3.5.1/bin/python3.5 /opt/Python-3.5.1/bin/python

# Requires copying of the module file at beginning of provisioning
module load python/3.5.1

curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python3.5

easy_install-3.5 pip
pip3.5 install --upgrade pip

pip3.5 install cython

# Install numpy, using openblas
cd /home/centos/src
pip3.5 install -d /home/centos/src numpy
tar xzf numpy-*.tar.gz
cd numpy-*

cp /home/centos/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install

cd /home/centos/src
rm -rf numpy*

# Install scipy, using openblas
cd /home/centos/src
pip3.5 install -d /home/centos/src scipy
tar xzf scipy-*.tar.gz
cd scipy-*

# # files uploaded by file provisioner
# # configuration for openblas, which should be at /opt/OpenBLAS/
cp /home/centos/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install

cd /home/centos/src
rm -rf scipy*

pip3.5 install -r /home/centos/python_requirements.txt

module unload python

## Cleanup
