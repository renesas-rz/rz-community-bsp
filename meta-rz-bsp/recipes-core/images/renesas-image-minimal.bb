# Copyright (c) 2023, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

SUMMARY = "Renesas minimal image based on core-image"
LICENSE = "MIT"

inherit core-image

# Image features we want to enable
IMAGE_FEATURES:append = " \
	package-management \
	splash \
	ssh-server-openssh \
"

# Packages we want to include
IMAGE_INSTALL:append = " \
	packagegroup-base \
	packagegroup-core-boot \
	${CORE_IMAGE_EXTRA_INSTALL} \
	kernel-image \
	kernel-devicetree \
"

# Packages that won't be included in the rootfs
EXTRA_IMAGEDEPENDS:append = " \
	virtual/bootloader \
"

IMAGE_LINGUAS = " "

IMAGE_ROOTFS_SIZE ?= "1048576"
