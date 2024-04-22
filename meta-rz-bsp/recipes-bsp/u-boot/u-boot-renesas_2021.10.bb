require u-boot-renesas.inc

SRC_URI:append = " \
	file://0001-rzg2-add-common-configuration-header.patch \
	file://0002-rzg2-add-generic-distro-boot-support.patch \
	file://0003-configs-rzg2-enable-CONFIG_DISTRO_DEFAULTS.patch \
	file://0004-configs-rzg2-add-support-for-environment-in-SD-card.patch \
"

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

SRCREV = "a2cf54552ab78b25acd7355c215a3bbc7679db2f"
BRANCH = "v2021.10/rz"
UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
