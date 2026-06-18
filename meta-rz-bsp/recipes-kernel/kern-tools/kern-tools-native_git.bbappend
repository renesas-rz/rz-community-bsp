# Fix kconfiglib to support 'depends on X if Y' syntax introduced in Linux 7.1
# Upstream kernel commit: 840b740a35bf969734e0f2e44c21289fdd03079e
# TODO: Remove when fix is available in upstream yocto-kernel-tools
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-kconfiglib-Support-conditional-depends-on-X-if-Y-syn.patch"
