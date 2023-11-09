require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

# Based on TF-A v2.9.0
SRCREV_tfa = "c314a391cf3eaf904e3b7a2875af15cc8254dab5"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
SRC_URI = "git://github.com/renesas-rz/rzg_trusted-firmware-a.git;branch=v2.9/rz;protocol=https;name=tfa"
