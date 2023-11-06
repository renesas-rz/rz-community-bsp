require recipes-bsp/trusted-firmware-a/trusted-firmware-a.inc

PROVIDES = "trusted-firmware-a"

COMPATIBLE_MACHINE = "hihope-rzg2h"

TFA_PLATFORM = "rzg"
TFA_BUILD_TARGET = "bl2 bl31 rzg"
TFA_INSTALL_TARGET = "bl2 bl31"
EXTRA_OEMAKE:append = " \
	LSI=G2H RCAR_DRAM_SPLIT=2 RCAR_DRAM_LPDDR4_MEMCONF=1 \
	RCAR_DRAM_CHANNEL=5 RCAR_AVS_SETTING_ENABLE=0 PMIC_ROHM_BD9571=0 \
	RCAR_SYSTEM_SUSPEND=0 RCAR_LOSSY_ENABLE=1 \
	RCAR_RPC_HYPERFLASH_LOCKED=0 RCAR_SA6_TYPE=0 \
"

# For hihope-rzg2h we need a number of files not installed by the meta-arm recipe
do_install:append() {
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
