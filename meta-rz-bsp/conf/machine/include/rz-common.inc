require conf/machine/include/soc-family.inc

MACHINE_FEATURES = ""
IMAGE_FSTYPES:append = " tar.gz"
SERIAL_CONSOLES = "115200;ttySC0"

# Linux kernel configuration
PREFERRED_PROVIDER_virtual/kernel ?= "linux-cip"
PREFERRED_VERSION_linux-cip ?= "6.1%"
KERNEL_IMAGETYPE ?= "Image"
