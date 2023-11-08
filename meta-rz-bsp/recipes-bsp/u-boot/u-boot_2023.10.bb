require u-boot-renesas.inc

COMPATIBLE_MACHINE = "hihope-rzg2h"

SRCREV = "4459ed60cb1e0562bc5b40405e2b4b9bbf766d57"
BRANCH = "master"
UBOOT_URL = "git://source.denx.de/u-boot/u-boot.git"

SRC_URI += "file://0001-Revert-net-ravb-Drop-reset-GPIO-handling-in-favor-of.patch"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
