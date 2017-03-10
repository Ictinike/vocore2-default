FROM ubuntu:14.04

LABEL maintainer="ictinike@gmail.com"
LABEL description="Dockerfile for VoCore2 SDK environment supporting Multiple Build Options."

ENV DEBIAN_FRONTEND noninteractive

# --------------------------------------------------------------------------------------------------------------
# -- Build Arg & Environment Variable For Build
# --------------------------------------------------------------------------------------------------------------
ARG BUILD_TYPE
ENV BUILD_TYPE ${BUILD_TYPE:-CONFIG_TARGET_ramips_mt7628_Default}

# --------------------------------------------------------------------------------------------------------------
# -- Firmware Build Types -- If Not Specified using --build-arg on Build; Default will be used
# --------------------------------------------------------------------------------------------------------------
# CONFIG_TARGET_ramips_mt7628_Default
# CONFIG_TARGET_ramips_mt7628_VOCORE2-128M
# CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-SD
# CONFIG_TARGET_ramips_mt7628_VOCORE2-LITE
# CONFIG_TARGET_ramips_mt7628_VOCORE2-BETA
# CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-SPIDEV
# CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-FLASHWRITE
# CONFIG_TARGET_ramips_mt7628_VOCORE2-128M-MAX-GPIO

# --------------------------------------------------------------------------------------------------------------
# -- Install Packages Needed
# --------------------------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
  gcc g++ git binutils patch bzip2 flex bison make autoconf gettext texinfo unzip sharutils subversion libncurses5-dev ncurses-term zlib1g-dev libssl-dev python gawk wget xz-utils \
&& rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------------------------------------------------
# -- Clone NoblePepper GitHub Repo For VoCore2
# --------------------------------------------------------------------------------------------------------------
RUN git clone https://github.com/noblepepper/openwrt-chaoscalmer.git openwrt-chaoscalmer

# --------------------------------------------------------------------------------------------------------------
# -- Add User and Security for newly cloned GIT
# --------------------------------------------------------------------------------------------------------------
#RUN useradd -m -d /home/vocore2 -p vocore2 vocore2 && adduser vocore sudo && chsh -s /bin/bash vocore2
#RUN adduser --disabled-password --no-create-home --gecos 'VoCore2 User' --home /opt/vocore2 vocore2
RUN adduser --disabled-password vocore2 &&  chown -R vocore2:vocore2 openwrt-chaoscalmer
#RUN adduser vocore2 &&  echo 'vocore2:vocore2' | chpasswd   && chown -R vocore2:vocore2 openwrt-chaoscalmer
WORKDIR openwrt-chaoscalmer
USER vocore2

# --------------------------------------------------------------------------------------------------------------
# -- Update VoCore2 Feeds and Install Updates
# --------------------------------------------------------------------------------------------------------------
RUN ./scripts/feeds update -a  && ./scripts/feeds install -a

# --------------------------------------------------------------------------------------------------------------
# -- Echo Configuration For Build Types and build Configuration File
# --------------------------------------------------------------------------------------------------------------
RUN echo CONFIG_TARGET_ramips=y > .config
RUN echo CONFIG_TARGET_ramips_mt7628=y >> .config
RUN echo $FORMAT=y >> .config
RUN make defconfig

# --------------------------------------------------------------------------------------------------------------
# -- Run MAKE to build ToolChain, Binaries and Build Firmware
# --------------------------------------------------------------------------------------------------------------
#RUN make
