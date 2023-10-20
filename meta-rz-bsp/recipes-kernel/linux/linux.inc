require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG ?= "defconfig"
KCONFIG_MODE ?= "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"
