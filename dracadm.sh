#!/usr/bin/env bash

# Name:         dracadm (docker racadm)
# Version:      0.1.7
# Release:      1
# License:      CC BY-NC-SA (Creative Commons Attribution-NonCommercial-ShareAlike)
#               http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Ubuntu Linux
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Shell script designed to provide racadm to platforms that can't run it via docker

SCRIPT_NAME="dracadm"
UBUNTU_VER="22.04"
UBUNTU_REL="jammy"
REQ_DEBS="libssl-dev ca-certificates wget libargtable2-0 pciutils"
OME_VER="11.0.0.0"
URL_VER=$(echo "$OME_VER" |sed "s/\.//g")
URL_BASE="https://linux.dell.com/repo/community/openmanage/$URL_VER/$UBUNTU_REL/pool/main/s"
PKG_1="srvadmin-hapi"
PKG_2="srvadmin-idracadm7"
PKG_3="srvadmin-idracadm8"
DEB_1="${PKG_1}_${OME_VER}_amd64.deb"
DEB_2="${PKG_2}_${OME_VER}_all.deb"
DEB_3="${PKG_3}_${OME_VER}_amd64.deb"
URL_1="$URL_BASE/$PKG_1/$DEB_1"
URL_2="$URL_BASE/$PKG_3/$DEB_2"
URL_3="$URL_BASE/$PKG_3/$DEB_3"
INFO_DIR="/var/lib/dpkg/info"
VAR_1="$INFO_DIR/$PKG_1.postinst"
VAR_2="$INFO_DIR/$PKG_2.postinst"
VAR_3="$INFO_DIR/$PKG_3.postinst"
WORK_DIR="$HOME/$SCRIPT_NAME"
PKG_BIN="/opt/dell/srvadmin/sbin/racadm-wrapper-idrac7"
RAC_BIN="/usr/bin/racadm"

# Get the version of the script from the script itself

SCRIPT_VERSION=$( grep '^# Version' < "$0" | awk '{print $3}' )

# Check work directory exists

check_workdir_exists () {
  if ! [ -e "$WORK_DIR" ]; then
    mkdir -p "$WORK_DIR"
  fi 
}

# Check docker is installed

check_docker_install () {
  if ! command -v docker > /dev/null 2>&1; then
    echo "Warning: docker not installed"
    exit 1
  fi
  if ! docker info > /dev/null 2>&1; then
    echo "Warning: docker daemon not running or not accessible"
    exit 1
  fi
  return
}

# Check docker container exists

check_docker_container () {
  if ! [ -f "/.dockerenv" ]; then
    if ! docker image inspect "$SCRIPT_NAME" > /dev/null 2>&1; then
      echo "version: \"3\"" > "$WORK_DIR/docker-compose.yml"
      echo "" >> "$WORK_DIR/docker-compose.yml"
      echo "services:" >> "$WORK_DIR/docker-compose.yml"
      echo "  $SCRIPT_NAME:" >> "$WORK_DIR/docker-compose.yml"
      echo "    build:" >> "$WORK_DIR/docker-compose.yml"
      echo "      context: ." >> "$WORK_DIR/docker-compose.yml"
      echo "      dockerfile: Dockerfile" >> "$WORK_DIR/docker-compose.yml"
      echo "    image: $SCRIPT_NAME" >> "$WORK_DIR/docker-compose.yml"
      echo "    container_name: $SCRIPT_NAME" >> "$WORK_DIR/docker-compose.yml"
      echo "    entrypoint: /bin/bash" >> "$WORK_DIR/docker-compose.yml"
      echo "    working_dir: /root" >> "$WORK_DIR/docker-compose.yml"
      echo "    platform: linux/amd64" >> "$WORK_DIR/docker-compose.yml"
      echo "FROM ubuntu:$UBUNTU_VER" > "$WORK_DIR/Dockerfile"
      echo "RUN apt-get update && apt-get install -y $REQ_DEBS && cd /tmp && wget $URL_1 && wget $URL_2 && wget $URL_3 && dpkg --unpack $DEB_1 && rm $VAR_1 && dpkg --configure -a && dpkg --unpack $DEB_2 && rm $VAR_2 && dpkg --configure -a && dpkg --unpack $DEB_3 && rm $VAR_3 && dpkg --configure -a && chmod +x $PKG_BIN && ln -sf $PKG_BIN $RAC_BIN && rm /tmp/*.deb" >> "$WORK_DIR/Dockerfile"
      docker build "$WORK_DIR" --tag "$SCRIPT_NAME" --platform "linux/amd64"
    fi
  else
    echo "Warning: Running inside docker"
    exit 1
  fi
}

# Print help

print_help () {
  cat <<-HELP

  Usage:   ${0##*/} [racadm commands...]

HELP
  exit
}

# If passed no arguments print help 

if [ $# -eq 0 ]; then
  print_help
fi

# Do some basic argument checking

if [ "$1" = "--version" ] || [ "$1" = "-V" ]; then
  echo "$SCRIPT_VERSION"
  exit
fi

# Check environment

check_workdir_exists
check_docker_install
check_docker_container

# Execute racadm via docker

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  docker run --rm --platform "linux/amd64" -t -v "$PWD":/work -w /work "$SCRIPT_NAME" "$RAC_BIN"
else
  docker run --rm --platform "linux/amd64" -t -v "$PWD":/work -w /work "$SCRIPT_NAME" "$RAC_BIN" "$@"
fi
