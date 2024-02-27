require conf/machine/include/arm/armv8-2a/tune-cortexa55.inc
require conf/machine/include/soc-family.inc

SOC_FAMILY = "rzg2l-family"
MACHINE_FEATURES = ""
IMAGE_FSTYPES:append = " tar.gz"
SERIAL_CONSOLES = "115200;ttySC0"

# Linux kernel configuration
PREFERRED_PROVIDER_virtual/kernel ?= "linux-cip"
PREFERRED_VERSION_linux-cip ?= "6.1%"
KERNEL_IMAGETYPE ?= "Image"

# U-Boot configuration
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot-renesas"
PREFERRED_VERSION_u-boot-renesas ?= "2021.10%"

# TF-A configuration
PREFERRED_PROVIDER_trusted-firmware-a ?= "trusted-firmware-a-renesas"
PREFERRED_VERSION_trusted-firmware-a-renesas ?= "2.9.0"
TFA_BUILD_TARGET = "bl2 bl31 fip"
TFA_INSTALL_TARGET = ""
TFA_UBOOT = "1"
