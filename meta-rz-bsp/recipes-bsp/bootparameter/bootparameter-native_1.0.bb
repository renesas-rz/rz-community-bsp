SECTION = "bootloaders"
DESCRIPTION = "Application to create initial bootloader binaries with the \
required header to boot on the RZ/G2L family of SoCs"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

inherit native

SRC_URI = "file://bootparameter.c"

# From Styhead onwards, S = "${WORKDIR}" is no longer supported and SRC_URI
# files unpack to UNPACKDIR instead. As we want to use the same recipe for all
# Yocto versions we use an anonymous Python function (rather than a static S
# assignment) to set S at runtime, avoiding the parse-time check that rejects
# any S = "${WORKDIR}" definition in Styhead/Whinlatter and newer.
python () {
    unpackdir = d.getVar('UNPACKDIR')
    if unpackdir:
        d.setVar('S', unpackdir)
    else:
        d.setVar('S', d.getVar('WORKDIR'))
}

do_compile () {
	${CC} bootparameter.c -o bootparameter
}

do_install () {
	install -d ${D}${bindir}
	install ${S}/bootparameter ${D}${bindir}
}
