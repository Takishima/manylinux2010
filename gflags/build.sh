#! /bin/bash

echo 'source scl_source enable devtoolset-8' >> ~/.bashrc
source scl_source enable devtoolset-8

yum install -y wget rpm-build rpmdevtools cmake3
alternatives --install /usr/local/bin/cmake cmake /usr/bin/cmake3 20 \
	     --slave /usr/local/bin/ctest ctest /usr/bin/ctest3 \
	     --slave /usr/local/bin/cpack cpack /usr/bin/cpack3 \
	     --slave /usr/local/bin/ccmake ccmake /usr/bin/ccmake3

/bin/cp -vr . /root/rpmbuild

mkdir -p /root/rpmbuild/SOURCES
echo cd /root/rpmbuild/SOURCES
cd /root/rpmbuild/SOURCES
GFLAGS_VERSION=2.2.2

wget http://github.com/schuhschuh/gflags/archive/v${GFLAGS_VERSION}/gflags-${GFLAGS_VERSION}.tar.gz

echo cd /root/rpmbuild/SPECS
cd /root/rpmbuild/SPECS

rpmbuild --define "debug_package %{nil}" \
	 -ba gflags.spec

cd /root/rpmbuild/RPMS
tar zcvf gflags_$(uname -p).tar.gz $(uname -p)/*
