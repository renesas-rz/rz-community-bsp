SECTION = "bootloaders"
DESCRIPTION = "Application to create initial bootloader binaries with the \
required header to boot on the RZ/G2L family of SoCs"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

inherit native

S = "${WORKDIR}"

SRC_URI = "file://bootparameter.c"

do_compile () {
	${CC} bootparameter.c -o bootparameter
}

do_install () {
	install -d ${D}${bindir}
	install ${WORKDIR}/bootparameter ${D}${bindir}
}
