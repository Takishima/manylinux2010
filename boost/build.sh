#! /bin/bash

echo 'source scl_source enable devtoolset-8' >> ~/.bashrc
source scl_source enable devtoolset-8

yum install -y git cmake3 wget rpm-build rpmdevtools
yum install -y openmpi-devel gcc-c++ xz-devel bzip2-devel zlib-devel libicu-devel

. /usr/share/Modules/init/sh
module load openmpi-x86_64

/opt/python/cp35-cp35m/bin/python3 -m pip install numpy
/opt/python/cp36-cp36m/bin/python3 -m pip install numpy
/opt/python/cp37-cp37m/bin/python3 -m pip install numpy
/opt/python/cp38-cp38/bin/python3  -m pip install numpy

cp -vr . /root/rpmbuild

echo cd /root/rpmbuild/SOURCES
cd /root/rpmbuild/SOURCES
BOOST_VERSION=1.73.0
wget https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION//./_}.tar.bz2

echo cd /root/rpmbuild/SPECS
cd /root/rpmbuild/SPECS
rpmbuild --without mpich -bb boost.spec
