FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# All currently supported RZ machines require the RAVB Ethernet driver built-in
SRC_URI:append:rzg2h-family = " file://ravb.cfg"
SRC_URI:append:rzg2l-family = " file://ravb.cfg"

# RZ/V2H uses GBETH instead of RAVB, built-in for NFS root
SRC_URI:append:rzv2h-evk = " file://gbeth.cfg"
