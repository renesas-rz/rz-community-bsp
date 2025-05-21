SECTION = "bootloaders"
DESCRIPTION = "Application to create initial bootloader binaries with the \
required header to boot on the RZ/G2L family of SoCs"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

inherit native

SRC_URI = "file://bootparameter.c"

# Yocto Styhead changed the way unpack is done in a way that isn't compatible
# with older versions of Yocto. Add some hackery so that the same recipe can be
# used with all of the Yocto versions we support.
S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"
do_unpack_extra () {
	find ${WORKDIR} -name bootparameter.c -exec  mv {} ${S} \;
}
addtask unpack_extra after do_unpack before do_patch

do_compile () {
	${CC} bootparameter.c -o bootparameter
}

do_install () {
	install -d ${D}${bindir}
	install ${UNPACKDIR}/bootparameter ${D}${bindir}
}
