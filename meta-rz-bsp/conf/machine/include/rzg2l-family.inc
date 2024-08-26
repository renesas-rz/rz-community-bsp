require conf/machine/include/arm/armv8-2a/tune-cortexa55.inc
require rz-common.inc

SOC_FAMILY = "rzg2l-family"

# U-Boot configuration
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot-renesas"
PREFERRED_VERSION_u-boot-renesas ?= "2021.10%"

# TF-A configuration
PREFERRED_PROVIDER_virtual/trusted-firmware-a ?= "trusted-firmware-a-renesas"
PREFERRED_VERSION_trusted-firmware-a-renesas ?= "2.9.0"
TFA_BUILD_TARGET = "bl2 bl31 fip"
TFA_INSTALL_TARGET = ""
TFA_UBOOT = "1"

IMAGE_FSTYPES:append = " wic.gz wic.bmap"
WKS_FILE = "rzg2l-sdcard.wks"
