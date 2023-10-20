DESCRIPTION = "Linux kernel from the Renesas RZ BSP v3.0.5 based on linux-5.10.y-cip"

require recipes-kernel/linux/linux-yocto.inc

KERNEL_URL = "git://github.com/renesas-rz/rz_linux-cip.git"
KBRANCH = "rz-5.10-cip36"
SRCREV = "1fa7acb4360944216070a41a9da26e6595c20998"

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
LINUX_VERSION = "5.10.184-cip36"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG = "defconfig"
KCONFIG_MODE = "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"
