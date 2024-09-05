require u-boot-renesas.inc

COMPATIBLE_MACHINE = "rzg2h-family"

SRCREV = "3f772959501c99fbe5aa0b22a36efe3478d1ae1c"
BRANCH = "master"
UBOOT_URL = "git://source.denx.de/u-boot/u-boot.git"

SRC_URI += " \
	file://0001-Revert-net-ravb-Drop-reset-GPIO-handling-in-favor-of.patch \
	file://0001-clk-renesas-rcar-gen3-Fix-the-shifts-calculated-for-.patch \
"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
