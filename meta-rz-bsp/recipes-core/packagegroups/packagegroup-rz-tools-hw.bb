# Copyright (c) 2024, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

DESCRIPTION = "Renesas Community set of packages for hardware test."
SUMMARY = "Renesas Community hw test packagegroup"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
	alsa-utils \
	alsa-tools \
	can-utils \
	dosfstools \
	evtest \
	e2fsprogs-mke2fs \
	i2c-tools \
	iproute2 \
	libgpiod \
	libgpiod-tools \
	memtester \
	mmc-utils \
	v4l-utils \
"
