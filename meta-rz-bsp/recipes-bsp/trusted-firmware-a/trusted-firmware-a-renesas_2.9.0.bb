require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

# Based on Renesas BSP v3.0.6-update3
SRCREV_tfa = "cc18695622e5637ec70ee3ae8eb5e83b09d13804"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
SRC_URI = "git://github.com/renesas-rz/rzg_trusted-firmware-a.git;branch=v2.9/rz;protocol=https;name=tfa"
