require conf/machine/include/arm/armv8-2a/tune-cortexa55.inc
require rz-common.inc

SOC_FAMILY = "rzv2h-family"

# U-Boot configuration
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot-renesas"
PREFERRED_VERSION_u-boot-renesas ?= "2024.07%"

# TF-A configuration
PREFERRED_PROVIDER_virtual/trusted-firmware-a ?= "trusted-firmware-a-renesas"
PREFERRED_VERSION_trusted-firmware-a-renesas ?= "2.10.5%"
TFA_PLATFORM ?= "v2h"
TFA_BUILD_TARGET = "bl2 bl31 fip"
TFA_INSTALL_TARGET = ""
TFA_UBOOT = "1"
