# Copyright (c) 2024, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

SUMMARY = "Graphics packages packagegroup."
DESCRIPTION = "Set of packages useful for graphics and hw acceleration"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
	glmark2 \
	gtk+3-demo \
	kmscube \
"
