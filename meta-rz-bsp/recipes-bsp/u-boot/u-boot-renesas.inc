require recipes-bsp/u-boot/u-boot-common.inc
require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "python3-setuptools-native bc-native dtc-native lzop-native"
PROVIDES += "u-boot"

SRC_URI = "${UBOOT_URL};protocol=https;branch=${BRANCH}"

UBOOT_SREC_SUFFIX = "srec"
UBOOT_SREC ?= "u-boot-elf.${UBOOT_SREC_SUFFIX}"
UBOOT_SREC_IMAGE ?= "u-boot-elf-${MACHINE}-${PV}-${PR}.${UBOOT_SREC_SUFFIX}"
UBOOT_SREC_SYMLINK ?= "u-boot-elf-${MACHINE}.${UBOOT_SREC_SUFFIX}"

# For the RZ/G2H platform we flash with SREC files so we need to add them to the
# deploy directory
do_deploy:append:hihope-rzg2h() {
	if [ -n "${UBOOT_CONFIG}" ]; then
		for config in ${UBOOT_MACHINE}; do
			i=$(expr $i + 1);
			for type in ${UBOOT_CONFIG}; do
				j=$(expr $j + 1);
				if [ $j -eq $i ]; then
					install -m 644 ${B}/${config}/${UBOOT_SREC} ${DEPLOYDIR}/u-boot-elf-${type}-${PV}-${PR}.${UBOOT_SREC_SUFFIX}
					cd ${DEPLOYDIR}
					ln -sf u-boot-elf-${type}-${PV}-${PR}.${UBOOT_SREC_SUFFIX} u-boot-elf-${type}.${UBOOT_SREC_SUFFIX}
				fi
			done
			unset j
		done
		unset i
	else
		install -m 644 ${B}/${UBOOT_SREC} ${DEPLOYDIR}/${UBOOT_SREC_IMAGE}
		cd ${DEPLOYDIR}
		rm -f ${UBOOT_SREC} ${UBOOT_SREC_SYMLINK}
		ln -sf ${UBOOT_SREC_IMAGE} ${UBOOT_SREC_SYMLINK}
		ln -sf ${UBOOT_SREC_IMAGE} ${UBOOT_SREC}
	fi
}
