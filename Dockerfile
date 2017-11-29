FROM ubuntu:16.04

# Based on Dockerfile from itsjeffreyy/sambamba image -- updated for kundajelab/sambamba

# install the system requirements
RUN \
	apt update --fix-missing \
	&& apt install -q -y wget g++ gcc make bzip2 git autoconf automake make g++ gcc build-essential zlib1g-dev libgsl0-dev  perl curl git wget unzip tabix libncurses5-dev python vim

WORKDIR /opt

# sambamba installation
# install sambamba needs ldc
RUN \
	wget https://github.com/ldc-developers/ldc/releases/download/v1.6.0/ldc2-1.6.0-linux-x86_64.tar.xz \
	&& tar xJf ldc2-1.6.0-linux-x86_64.tar.xz

ENV PATH=/opt/ldc2-1.6.0-linux-x86_64/bin/:$PATH
ENV LIBRARY_PATH=/opt/ldc2-1.6.0-linux-x86_64/lib/

#install kundajelab fork of sambamba 
RUN \
	git clone --recursive https://github.com/kundajelab/sambamba.git \
	&& cd /opt/sambamba \
	&& make -j 8 sambamba-ldmd2-64 

# reduce image size
RUN \
	apt-get autoremove -y \
	&& rm -f /opt/ldc2-1.6.0-linux-x86_64.tar.xz

# set environment
ENV PATH=/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/opt/sambamba/build/:$PATH

VOLUME /opt/sambamba-dev
WORKDIR /root

