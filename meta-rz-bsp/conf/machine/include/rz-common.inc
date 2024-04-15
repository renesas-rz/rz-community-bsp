require conf/machine/include/soc-family.inc

MACHINE_FEATURES = ""
IMAGE_FSTYPES:append = " tar.gz"
SERIAL_CONSOLES = "115200;ttySC0"

# Linux kernel configuration
PREFERRED_PROVIDER_virtual/kernel ?= "linux-cip"
PREFERRED_VERSION_linux-cip ?= "6.1%"
KERNEL_IMAGETYPE ?= "Image"
KERNEL_DEVICETREE ?= "renesas/${KERNEL_DEVICETREE_BASENAME}.dtb"

# Yocto Scarthgap has increased OLDEST_KERNEL to 5.15 but we have the option to
# build 5.10 with this meta-layer. Override OLDEST_KERNEL to allow this
OLDEST_KERNEL = "5.10"

# SD/MMC configuration:
ROOT_PARENT_DEV = "/dev/mmcblk0"
ROOT_PART_PREFIX = "p"
ROOT_PART_ID = "1"

# EXTLINUX configuration (needed by distroboot):
UBOOT_EXTLINUX = "1"
UBOOT_EXTLINUX_CONSOLE = ""
UBOOT_EXTLINUX_ROOT = "root=${ROOT_PARENT_DEV}${ROOT_PART_PREFIX}${ROOT_PART_ID}"
UBOOT_EXTLINUX_FDT = "/boot/${KERNEL_DEVICETREE_BASENAME}.dtb"
