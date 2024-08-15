require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG ?= "defconfig"
KCONFIG_MODE ?= "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"

# RZ/G2H family needs firware for USB3
LICENSE:append:rzg2h-family = " & r8a778x_usb3_fw_license"
SRC_URI:append:rzg2h-family = " \
	file://r8a779x_usb3_v3.dlmem \
	file://usb3.cfg \
"

do_configure:append:rzg2h-family () {
	install -d ${STAGING_KERNEL_DIR}/firmware
	install -m 755 ${WORKDIR}/r8a779x_usb3_v3.dlmem ${STAGING_KERNEL_DIR}/firmware
}
