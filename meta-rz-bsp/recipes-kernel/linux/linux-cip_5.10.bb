DESCRIPTION = "CIP SLTS Linux kernel v5.10"

require linux.inc

KERNEL_URL = "git://gitlab.com/cip-project/cip-kernel/linux-cip.git"
KBRANCH = "linux-5.10.y-cip"
SRCREV = "ef24e6dcf682f112bcdbb5b39cbed7a8cedcfd46"

LINUX_VERSION = "5.10.271-cip78"

# OpenSSL 4.0 (Yocto Blacksail) removes the ENGINE API
SRC_URI += "${@bb.utils.contains('LAYERSERIES_CORENAMES', 'blacksail', 'file://0001-scripts-Build-extract-cert-and-sign-file-without-Open.patch', '', d)}"
