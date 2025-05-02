require u-boot-renesas.inc

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

# Based on Renesas BSP v3.0.7
SRCREV = "50bafe75d5c489593535b118f27067209014f082"
BRANCH = "v2021.10/rz"
UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"

LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
