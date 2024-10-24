require rz-common.inc

SOC_FAMILY = "rzg2h-family"

# U-Boot configuration
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
PREFERRED_VERSION_u-boot ?= "2024.10%"

# TF-A configuration
PREFERRED_PROVIDER_virtual/trusted-firmware-a ?= "trusted-firmware-a"
PREFERRED_VERSION_trusted-firmware-a ?= "2.10.5"
TFA_PLATFORM ?= "rzg"
TFA_BUILD_TARGET = "bl2 bl31 rzg"
TFA_INSTALL_TARGET = ""
