require u-boot-renesas.inc

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

# Based on Renesas BSP v3.0.6-update3
SRCREV = "5141064c1552accaf69c6f509bf21b2063b9cff5"
BRANCH = "v2021.10/rz"
UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
