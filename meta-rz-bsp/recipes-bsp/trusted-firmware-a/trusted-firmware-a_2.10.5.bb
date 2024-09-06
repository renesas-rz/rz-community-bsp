require trusted-firmware-a-renesas.inc

COMPATIBLE_MACHINE = "rzg2h-family"

# TF-A v2.10.5
SRCREV_tfa = "7c229848a09ebc3aba8e3941ae1cdfceb222a768"
SRCBRANCH = "lts-v2.10"

# meta-arm kirkstone hardcodes the branch to master which doesn't contain the
# latest lts-v2.10 commits. Overwrite SRC_URI so we can use the correct branch.
SRC_URI:remove = "git://git.trustedfirmware.org/TF-A/trusted-firmware-a.git;protocol=https;name=tfa;branch=master"
SRC_URI = "git://git.trustedfirmware.org/TF-A/trusted-firmware-a.git;protocol=https;name=tfa;branch=${SRCBRANCH}"
SRC_URI:remove = "file://ssl.patch"

LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b2c740efedc159745b9b31f88ff03dde"
