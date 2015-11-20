#!/bin/bash -x

# Need this for module loading
source /etc/profile.d/modules.sh

cd /root/src/

yum makecache
yum install -y ed less wget
yum install -y python python-devel

# Install newer version of python 2
# Will require a module file
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar xzf Python-2.7.10.tgz
cd Python-2.7.10
mkdir /opt/Python-2.7.10/
./configure --prefix=/opt/Python-2.7.10/ --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall
cd ..

ln -s /opt/Python-2.7.10/bin/python2.7 /opt/Python-2.7.10/bin/python

# Requires copying of the module file at beginning of provisioning
module load python/2.7.10

curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | /opt/Python-2.7.10/bin/python2.7

/opt/Python-2.7.10/bin/easy_install pip
pip2.7 install --upgrade pip

pip2.7 install cython

# Install numpy, using openblas
cd /root/src
pip install -d /root/src numpy
tar xzf numpy-.*.tar.gz
cd numpy-.*

# # files uploaded by file provisioner
# # configuration for openblas, which should be at /opt/OpenBLAS/
cp /home/ec2-user/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install
# python setup.py clean && python setup.py build && python setup.py install

cd /root/src
rm -rf numpy*

## Need this to get the lib; should be in the python modulefile
# export LD_LIBRARY_PATH=/opt/OpenBLAS/lib:$LD_LIBRARY_PATH

pip2.7 install ipython
pip2.7 install virtualenv
pip2.7 install pandas
pip2.7 install awscli
pip2.7 install scipy
pip2.7 install matplotlib
pip2.7 install seaborn
pip2.7 install patsy
pip2.7 install statsmodels
pip2.7 install scikit-learn

## Synapse Python client (only for python 2)
## Fixes an InsecurePlatformWarning
module unload python
# yum -y remove pyOpenSSL
yum -y install libffi-devel openssl-devel
module load python/2.7.10

pip2.7 install pyopenssl==0.15.1 ndg-httpsclient pyasn1
pip2.7 install synapseclient

module unload python/2.7.10

# Install python 3
# Can use a module file
wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
tar xzf Python-3.4.3.tgz
cd Python-3.4.3
mkdir /opt/Python-3.4.3/
./configure --prefix=/opt/Python-3.4.3/ --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
    make && make altinstall

cd ..

ln -s /opt/Python-3.4.3/bin/python3.4 /opt/Python-3.4.3/bin/python

# Requires copying of the module file at beginning of provisioning
module load python/3.4.3

curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python3.4

easy_install-3.4 pip
pip3.4 install --upgrade pip

pip3.4 install cython

# Install numpy, using openblas
cd /root/src
pip install -d /root/src numpy
tar xzf numpy-*.tar.gz
cd numpy-*

cp /home/ec2-user/numpy/site.cfg .

unset CPPFLAGS
unset LDFLAGS
python setup.py clean && python setup.py build --fcompiler=gnu95 && python setup.py install
# python setup.py clean && python setup.py build && python setup.py install

cd /root/src
rm -rf numpy*

pip3.4 install ipython
pip3.4 install virtualenv
pip3.4 install snakemake
pip3.4 install pandas
pip3.4 install awscli
pip3.4 install scipy
pip3.4 install matplotlib
pip3.4 install seaborn
pip3.4 install patsy
pip3.4 install statsmodels
pip3.4 install scikit-learn

module unload python

## Cleanup
