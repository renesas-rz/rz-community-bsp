FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# All currently supported RZ machines require the RAVB Ethernet driver built-in
SRC_URI:append:rzg2h-family = " file://ravb.cfg"
SRC_URI:append:rzg2l-family = " file://ravb.cfg"
