require u-boot-renesas.inc

COMPATIBLE_MACHINE = "rzv2h-evk"

DEPENDS += "gnutls-native"

# Based on Renesas RZ BSP v5.0.1 (tag v2024.07/rz_5.0.1)
SRCREV = "013e59f7aebc067f1018ab51c53563ab2854366c"
SRC_URI = "${UBOOT_URL};protocol=https;nobranch=1"
UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756634782f1"
