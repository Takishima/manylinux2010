#
# Macros for cmake3
#
%_cmake3_lib_suffix64 -DLIB_SUFFIX=64
%_cmake3_shared_libs -DBUILD_SHARED_LIBS:BOOL=ON
%_cmake3_skip_rpath -DCMAKE_SKIP_RPATH:BOOL=ON
%_cmake3_version @@CMAKE_VERSION@@
%__cmake3 /usr/bin/cmake3

# - Set default compile flags
# - CMAKE_*_FLAGS_RELEASE are added *after* the *FLAGS environment variables
# and default to -O3 -DNDEBUG.  Strip the -O3 so we can override with *FLAGS
# - Turn on verbose makefiles so we can see and verify compile flags
# - Set default install prefixes and library install directories
# - Turn on shared libraries by default
%cmake3 \
  CFLAGS="${CFLAGS:-%optflags}" ; export CFLAGS ; \
  CXXFLAGS="${CXXFLAGS:-%optflags}" ; export CXXFLAGS ; \
  FFLAGS="${FFLAGS:-%optflags%{?_fmoddir: -I%_fmoddir}}" ; export FFLAGS ; \
  FCFLAGS="${FCFLAGS:-%optflags%{?_fmoddir: -I%_fmoddir}}" ; export FCFLAGS ; \
  %{?__global_ldflags:LDFLAGS="${LDFLAGS:-%__global_ldflags}" ; export LDFLAGS ;} \
  %__cmake3 \\\
        -DCMAKE_C_FLAGS_RELEASE:STRING="-DNDEBUG" \\\
        -DCMAKE_CXX_FLAGS_RELEASE:STRING="-DNDEBUG" \\\
        -DCMAKE_Fortran_FLAGS_RELEASE:STRING="-DNDEBUG" \\\
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \\\
        -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \\\
        -DINCLUDE_INSTALL_DIR:PATH=%{_includedir} \\\
        -DLIB_INSTALL_DIR:PATH=%{_libdir} \\\
        -DSYSCONF_INSTALL_DIR:PATH=%{_sysconfdir} \\\
        -DSHARE_INSTALL_PREFIX:PATH=%{_datadir} \\\
%if "%{?_lib}" == "lib64" \
        %{?_cmake3_lib_suffix64} \\\
%endif \
        %{?_cmake3_shared_libs}
