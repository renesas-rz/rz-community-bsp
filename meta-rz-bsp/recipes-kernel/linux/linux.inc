require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "${KERNEL_URL};protocol=https;branch=${KBRANCH}"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

PV = "${LINUX_VERSION}+git${SRCPV}"

KBUILD_DEFCONFIG ?= "defconfig"
KCONFIG_MODE ?= "alldefconfig"

DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native libmpc-native"

# All currently supported RZ machines require the RAVB Ethernet driver built-in
SRC_URI:append:rzg2h-family = " file://ravb.cfg"
SRC_URI:append:rzg2l-family = " file://ravb.cfg"

# RZ/G2H family needs firware for USB3
# Scarthgap and Wrynose only support the legacy LICENSE syntax, newer releases
# expect SPDX license expressions.
LICENSE:append:rzg2h-family = "${@bb.utils.contains_any( \
	'LAYERSERIES_CORENAMES', 'scarthgap wrynose', \
	' & r8a778x-usb3-fw-license', \
	' AND LicenseRef-r8a778x-usb3-fw-license', d)}"
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
