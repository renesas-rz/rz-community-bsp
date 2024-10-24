require u-boot-renesas.inc

COMPATIBLE_MACHINE = "rzg2h-family"

DEPENDS += "gnutls-native"

SRCREV = "f919c3a889f0ec7d63a48b5d0ed064386b0980bd"
BRANCH = "master"
UBOOT_URL = "git://source.denx.de/u-boot/u-boot.git"

SRC_URI += " \
	file://0001-configs-hihope_rzg2-Set-correct-MMC-device-for-U-Boo.patch \
	file://0002-board-hoperun-Switch-to-use-complete-DTS-files-from-.patch \
"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
