require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family)"

# Based on Renesas BSP v3.0.7-update3
SRCREV_tfa = "69ad8fc4d38f31cddbfd9dfc8cccfb6b8609dcb9"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
SRC_URI = "git://github.com/renesas-rz/rzg_trusted-firmware-a.git;branch=v2.9/rz;protocol=https;name=tfa"

# In TF-A v2.10.0, the variable containing linker arguments in the fiptool
# Makefile was changed from `LDLIBS` to `LDOPTS`.
#
# When building with the Yocto scarthgap branch, the trusted-firmware-a.inc
# file in meta-arm handles modification of the LDOPTS variable for TF-A 2.10.0
# or later. So to fix the build with Scarthgap and TF-A 2.9.0 we need to modify
# the LDLIBS variable ourselves.
do_compile:prepend() {
	sed -i '/^LDLIBS/ s,$, \$\{BUILD_LDFLAGS},' ${S}/tools/fiptool/Makefile
}
