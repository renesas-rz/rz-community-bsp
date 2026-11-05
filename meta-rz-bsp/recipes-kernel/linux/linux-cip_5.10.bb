DESCRIPTION = "CIP SLTS Linux kernel v5.10"

require linux.inc

KERNEL_URL = "git://gitlab.com/cip-project/cip-kernel/linux-cip.git"
KBRANCH = "linux-5.10.y-cip"
SRCREV = "dd1167bd1a0ad96d0e8de9aa09ca452f949ba3a7"

LINUX_VERSION = "5.10.272-cip79"

# OpenSSL 4.0 (Yocto Blacksail) removes the ENGINE API
SRC_URI += "${@bb.utils.contains('LAYERSERIES_CORENAMES', 'blacksail', 'file://0001-scripts-Build-extract-cert-and-sign-file-without-Open.patch', '', d)}"
