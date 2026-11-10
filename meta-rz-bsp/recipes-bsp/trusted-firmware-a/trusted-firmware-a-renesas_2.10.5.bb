require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "rzv2h-evk"

# Based on Renesas RZ BSP v5.0.1 (tag 2.10.5/rz_5.0.1)
SRCREV_tfa = "d6806e3f0a155ecfe03f8adad188beb4a9194812"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
SRC_URI = "git://github.com/renesas-rz/rzg_trusted-firmware-a.git;protocol=https;nobranch=1;name=tfa"
