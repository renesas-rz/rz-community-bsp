# Copyright (c) 2024, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

SUMMARY = "Hardware testing packagegroup."
DESCRIPTION = "Set of packages useful for hardware testing."

# This is required to avoid "ERROR: packagegroup-rz-tools-hw-1.0-r0
# do_package_write_rpm: An allarch packagegroup shouldn't depend on packages
# which are dynamically renamed (libgpiod to libgpiod3"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
	alsa-tools \
	alsa-utils \
	can-utils \
	dosfstools \
	e2fsprogs-mke2fs \
	evtest \
	i2c-tools \
	iproute2 \
	libgpiod \
	libgpiod-tools \
	memtester \
	mmc-utils \
	v4l-utils \
"
