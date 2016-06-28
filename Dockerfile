###############################################################
# Dockerfile to build an ubuntu image with all dependencies
# needed to build icetray
###############################################################

FROM ubuntu:latest

MAINTAINER Claudio Kopper <ckopper@icecube.wisc.edu>

WORKDIR /root

# install system packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  tar wget rsync gzip bzip2 xz-utils liblzma5 liblzma-dev zlib1g zlib1g-dev \
  less build-essential cmake libbz2-dev libgl1-mesa-dev \
  freeglut3-dev libxml2-dev subversion libboost-python-dev \
  libboost-system-dev libboost-signals-dev libboost-thread-dev \
  libboost-date-time-dev libboost-serialization-dev \
  libboost-filesystem-dev libboost-program-options-dev \
  libboost-regex-dev libboost-iostreams-dev libgsl0-dev \
  libcdk5-dev libarchive-dev python-scipy ipython-notebook \
  libqt4-dev python-urwid python-numpy python-matplotlib \
  libz-dev libqt4-opengl-dev libstarlink-pal-dev \
  python-sphinx libopenblas-dev libcfitsio3-dev libsprng2-dev \
  libmysqlclient-dev libsuitesparse-dev \
  libcfitsio3-dev libmysqlclient-dev libhdf5-serial-dev \
  python-requests python-pyfits python-numexpr cython python-cffi \
  python-healpy python-urwid python-urllib3 python-jsonschema \
  python-virtualenv python-openssl python-pyasn1 python-coverage \
  python-flexmock libzmq5 libzmq3-dev libzmqpp-dev libzmqpp3 python-zmq \
  python-tornado python-tables python-fftw gnuplot python-gnuplot \
  python-dev python-pip root-system \
  && apt-get clean

# install AMD OpenCL
COPY amd_sdk.sh /root/
RUN /bin/bash amd_sdk.sh && \
    tar -jx -f /root/AMD-SDK.tar.bz2 -C /root && \
    rm /root/AMD-SDK.tar.bz2 /root/amd_sdk.sh && \
    /bin/sh /root/AMD-APP-SDK-v3.0.130.136-GA-linux32.sh -- --acceptEULA 'yes' -s && \
    rm /root/AMD-APP-SDK-*.sh && rm -rf /root/AMDAPPSDK-* && \
    rm -rf /opt/AMDAPPSDK-*/samples/{aparapi,bolt,opencv} && \
    ln -sf /opt/AMDAPPSDK-3.0/include/CL /usr/include/ && \
    ln -sf /opt/AMDAPPSDK-3.0/lib/x86_64/sdk/libOpenCL.so.1 /usr/lib/libOpenCL.so.1 && \
    ln -sf /opt/AMDAPPSDK-3.0/lib/x86_64/sdk/libOpenCL.so /usr/lib/libOpenCL.so && \
    ln -sf /opt/AMDAPPSDK-3.0/lib/x86_64/sdk/libamdocl64.so /usr/lib/libamdocl64.so && \
    ln -sf /opt/AMDAPPSDK-3.0/bin/x86_64/clinfo /usr/bin/clinfo

# create an icecube user
RUN groupadd icecube && useradd -g icecube -d /home/icecube --create-home icecube
USER icecube
WORKDIR /home/icecube
