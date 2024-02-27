require conf/machine/include/arm/armv8a/tune-cortexa73-cortexa53.inc
require conf/machine/include/soc-family.inc

SOC_FAMILY = "rzg2h-family"
MACHINE_FEATURES = ""
IMAGE_FSTYPES:append = " tar.gz"
SERIAL_CONSOLES = "115200;ttySC0"

# Linux kernel configuration
PREFERRED_PROVIDER_virtual/kernel ?= "linux-cip"
PREFERRED_VERSION_linux-cip ?= "6.1%"
KERNEL_IMAGETYPE ?= "Image"

# U-Boot configuration
PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
PREFERRED_VERSION_u-boot ?= "2023.10%"

# TF-A configuration
PREFERRED_PROVIDER_trusted-firmware-a ?= "trusted-firmware-a"
PREFERRED_VERSION_trusted-firmware-a ?= "2.9.0"
