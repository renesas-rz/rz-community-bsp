require recipes-bsp/trusted-firmware-a/trusted-firmware-a.inc

DEPENDS += "bootparameter-native"
PROVIDES = "trusted-firmware-a"

TFA_PLATFORM:rzg2h-family = "rzg"
TFA_BUILD_TARGET:rzg2h-family = "bl2 bl31 rzg"
TFA_INSTALL_TARGET:rzg2h-family = ""
EXTRA_OEMAKE:append:hihope-rzg2h = " \
	LSI=G2H RCAR_DRAM_SPLIT=2 RCAR_DRAM_LPDDR4_MEMCONF=1 \
	RCAR_DRAM_CHANNEL=5 RCAR_AVS_SETTING_ENABLE=0 PMIC_ROHM_BD9571=0 \
	RCAR_SYSTEM_SUSPEND=0 RCAR_LOSSY_ENABLE=1 \
	RCAR_RPC_HYPERFLASH_LOCKED=0 RCAR_SA6_TYPE=0 \
"

TFA_PLATFORM:rzg2l-family = "g2l"
TFA_BUILD_TARGET:rzg2l-family = "bl2 bl31 fip"
TFA_INSTALL_TARGET:rzg2l-family = ""
EXTRA_OEMAKE:append:smarc-rzg2l = " \
	BOARD=smarc_pmic_2 \
"
# Activate U-Boot so we can build it into a fip package
TFA_UBOOT:rzg2l-family = "1"

# For the RZ/G2L family of SoCs we need a version of bl2 with a special header
# We also need to use SREC files
do_compile:append:rzg2l-family() {
	echo "Create bl2_bp.bin"
	bootparameter ${BUILD_DIR}/bl2.bin ${BUILD_DIR}/bl2_bp.bin
	cat ${BUILD_DIR}/bl2.bin >> ${BUILD_DIR}/bl2_bp.bin

	echo "Convert bl2_bp.bin to bl2_bp.srec"
	objcopy -O srec --adjust-vma=0x00011E00 --srec-forceS3 -I binary ${BUILD_DIR}/bl2_bp.bin ${BUILD_DIR}/bl2_bp.srec

	echo "Convert fip.bin to fip.srec"
	objcopy -I binary -O srec --adjust-vma=0x0000 --srec-forceS3 ${BUILD_DIR}/fip.bin ${BUILD_DIR}/fip.srec
}

# For the RZ/G2H family of SoCs we need a number of files not installed by the
# meta-arm recipe
do_install:append:rzg2h-family() {
	echo "Install bl2.srec"
	install -m 0644 ${BUILD_DIR}/bl2.srec ${D}/firmware/bl2-${MACHINE}.srec

	echo "Install bl31.srec"
	install -m 0644 ${BUILD_DIR}/bl31.srec ${D}/firmware/bl31-${MACHINE}.srec

	echo "Install bootparam_sa0.srec"
	install -m 0644 ${S}/tools/renesas/rzg_layout_create/bootparam_sa0.srec \
		${D}/firmware/bootparam_sa0.srec

	echo "Install cert_header_sa6.srec"
	install -m 0644 ${S}/tools/renesas/rzg_layout_create/cert_header_sa6.srec \
		${D}/firmware/cert_header_sa6.srec
}

# Install files we need for the RZ/G2L family of SoCs that are not installed by
# the meta-arm recipe
do_install:append:rzg2l-family() {
	echo "Install bl2_bp.srec"
	install -m 0644 ${BUILD_DIR}/bl2_bp.srec ${D}/firmware/bl2_bp-${MACHINE}.srec

	echo "Install fip.srec"
	install -m 0644 ${BUILD_DIR}/fip.srec ${D}/firmware/fip-${MACHINE}.srec
}
