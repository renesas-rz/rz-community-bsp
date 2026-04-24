# Copyright (c) 2024, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

SUMMARY = "Graphics packages packagegroup."
DESCRIPTION = "Set of packages useful for graphics and hw acceleration"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} += "\
	${@bb.utils.contains('DISTRO_FEATURES', 'opengl', 'kmscube', '', d)} \
	${@bb.utils.contains_any('DISTRO_FEATURES', 'opengl dispmanx', 'glmark2', '', d)} \
	${@bb.utils.contains_any('DISTRO_FEATURES', 'x11 wayland', 'gtk+3-demo', '', d)} \
"
