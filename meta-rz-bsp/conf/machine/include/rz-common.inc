require conf/machine/include/soc-family.inc

MACHINE_FEATURES = "serial screen usbhost"
IMAGE_FSTYPES:append = " tar.gz"
SERIAL_CONSOLES = "115200;ttySC0"

# Linux kernel configuration
PREFERRED_PROVIDER_virtual/kernel ?= "linux-cip"
PREFERRED_VERSION_linux-cip ?= "6.1%"
KERNEL_IMAGETYPE ?= "Image"

# Yocto Scarthgap has increased OLDEST_KERNEL to 5.15 but we have the option to
# build 5.10 with this meta-layer. Override OLDEST_KERNEL to allow this
OLDEST_KERNEL = "5.10"

# Other dependencies that aren't included in the rootfs
EXTRA_IMAGEDEPENDS += " \
	flash-writer \
	virtual/bootloader \
	virtual/trusted-firmware-a \
"
