require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "hihope-rzg2h"

# TF-A v2.9.0
SRCREV_tfa = "d3e71ead6ea5bc3555ac90a446efec84ef6c6122"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
SRC_URI:remove = "file://ssl.patch"
