#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.1"
BOARD_NAME="ipq40xx"
BOARD_SUBNAME="generic"
BUILDER="https://downloads.openwrt.org/releases/23.05.0-rc2/targets/ipq40xx/generic/openwrt-imagebuilder-23.05.0-rc2-ipq40xx-generic.Linux-x86_64.tar.xz"
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

make image  PROFILE="glinet_gl-a1300" \
           PACKAGES="block-mount kmod-fs-ext4 kmod-usb-storage blkid mount-utils swap-utils e2fsprogs fdisk luci dnsmasq" \
           FILES="/home/i9box/Desktop/GLI_A1300/openwrt-glinet-gl-b1300-main/files/" \
           BIN_DIR="$OUTPUT"
