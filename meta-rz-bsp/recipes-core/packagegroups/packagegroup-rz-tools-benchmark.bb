# Copyright (c) 2024, Renesas Electronics Corp.
#
# SPDX-License-Identifier: MIT

SUMMARY = "Benchmark packages packagegroup."
DESCRIPTION = "Set of packages useful for hw benchmark"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
	bonnie++ \
	iperf3 \
	stress-ng \
"
