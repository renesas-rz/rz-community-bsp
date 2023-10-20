DESCRIPTION = "CIP SLTS Linux kernel v6.1"

require recipes-kernel/linux/linux-yocto.inc

KERNEL_URL = "git://git.kernel.org/pub/scm/linux/kernel/git/cip/linux-cip.git"
KBRANCH = "linux-6.1.y-cip"
SRCREV = "5608f0095a5ba83c76af0e5824c2e2d3f41231b5"

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LINUX_VERSION = "6.1.58-cip7"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG = "defconfig"
KCONFIG_MODE = "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"
