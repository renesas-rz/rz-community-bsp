require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG ?= "defconfig"
KCONFIG_MODE ?= "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"

SRC_URI:append = "\
		${@bb.utils.contains('DISTRO_FEATURES', 'docker', 'file://docker.cfg', '', d)} \
	"

# RZ/G2H family needs firware for USB3
LICENSE:append:rzg2h-family = " & r8a778x_usb3_fw_license"
SRC_URI:append:rzg2h-family = " \
	file://r8a779x_usb3_v3.dlmem \
	file://usb3.cfg \
"

do_configure:append:rzg2h-family () {
	# Yocto Styhead changed the way unpack is done in a way that isn't
	# compatible with older versions of Yocto. This results in some files
	# being unpaced to different locations depending on the Yocto verison.
	# Use the new UNPACKDIR variable to help guide where we should expect to
	# find these files.
	FIRMWAREDIR="${@d.getVar('UNPACKDIR', True) if d.getVar('UNPACKDIR') else d.getVar('WORKDIR', True)}"
	install -d ${STAGING_KERNEL_DIR}/firmware
	install -m 755 ${FIRMWAREDIR}/r8a779x_usb3_v3.dlmem ${STAGING_KERNEL_DIR}/firmware
}

ERROR_QA:remove = "buildpaths"
