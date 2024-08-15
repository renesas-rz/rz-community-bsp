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

IMAGE_LINGUAS = " "

IMAGE_ROOTFS_SIZE ?= "1048576"

IMAGE_NAME_SUFFIX = ""
