#! /bin/bash

# ==============================================================================

_pycall()
{
    PY_ROOT=$1
    shift
    PATH=$PY_ROOT/bin:$PATH "$@"
}

_pyversion()
{
    _pycall "$1" "$2" -c 'import sys; print("%i.%i" % (sys.version_info.major, sys.version_info.minor))'
}

# ==============================================================================

echo 'source scl_source enable devtoolset-8' >> ~/.bashrc
source scl_source enable devtoolset-8

yum install -y git cmake3 wget rpm-build rpmdevtools
yum install -y openmpi-devel gcc-c++ xz-devel bzip2-devel zlib-devel libicu-devel

. /usr/share/Modules/init/sh
module load openmpi-$(uname -i)

_tmp=""
pyver_list=""
for py_root in /opt/python/cp3*; do
    _pycall "$py_root" python3 -m pip install numpy
    echo $(_pycall "$py_root" python3 --version)
    PY3_VERSION="$(_pyversion "$py_root" python3)"
    pyver_list="${pyver_list},$PY3_VERSION"
    abiflags="$(_pycall "$py_root" python3-config --abiflags)"
    py_prefix="$(_pycall "$py_root" python3-config --prefix)"

    _tmp="$_tmp\nusing python : ${PY3_VERSION:+$PY3_VERSION }: "
    _tmp="$_tmp${PY3_VERSION:+${py_prefix}/bin/python3 }: "
    _tmp="$_tmp${PY3_VERSION:+${py_prefix}/include/python${PY3_VERSION}${abiflags} }: "
    _tmp="$_tmp${PY3_VERSION:+${py_prefix}/lib };"
done
python_user_config=$_tmp
pyver_list=${pyver_list/,}

sed -e "s/PYTHON_VERSION_LIST/$pyver_list/" -e "s|PYTHON_USER_CONFIG_JAM|$python_user_config|" SPECS/boost.spec.in > SPECS/boost.spec

/bin/cp -vr . /root/rpmbuild

echo cd /root/rpmbuild/SOURCES
cd /root/rpmbuild/SOURCES
BOOST_VERSION=1.73.0
wget https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/boost_${BOOST_VERSION//./_}.tar.bz2

echo cd /root/rpmbuild/SPECS
cd /root/rpmbuild/SPECS

rpmbuild --without mpich -ba boost.spec

cd /root/rpmbuild/RPMS
tar zcvf boost173_$(uname -p).tar.gz $(uname -p)/*
