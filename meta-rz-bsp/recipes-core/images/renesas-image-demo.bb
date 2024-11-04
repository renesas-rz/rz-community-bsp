# Copyright (c) 2023, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

require renesas-image-minimal.bb

SUMMARY = "Renesas demo"
LICENSE = "MIT"

IMAGE_FEATURES += " weston"

CORE_IMAGE_BASE_INSTALL += " \
	glmark2 \
	gtk+3-demo \
	kmscube \
	packagegroup-rz-tools-hw \
"
