FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# All currently supported RZ machines require the RAVB Ethernet driver built-in
SRC_URI:append:rzg2h-family = " file://ravb.cfg"
SRC_URI:append:rzg2l-family = " file://ravb.cfg"

# Fix kconfiglib dependency loop in v7.4-rc1 (breaks do_kernel_configcheck).
# Drop once the upstream fix is in the mainline release being built.
SRC_URI:append = "${@' file://0001-platform-arm64-drop-the-vacuous-THERMAL-dependency-f.patch' if d.getVar('LINUX_VERSION').startswith('7.4-rc') else ''}"

# RZ/V2H uses GBETH instead of RAVB, built-in for NFS root
SRC_URI:append:rzv2h-evk = " file://gbeth.cfg"
