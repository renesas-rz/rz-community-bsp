DESCRIPTION = "Flash Writer tool to write binaries to flash on the target"
LICENSE = "BSD-3-Clause"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(rzg2h-family|rzg2l-family|rzv2h-family)"

FLASH_WRITER_URL = "git://github.com/renesas-rz/rzg2_flash_writer"

BRANCH = "rz_g2l"
SRCREV = "ff167b676547f3997906c82c9be504eb5cff8ef0"
PV = "1.06+git${SRCPV}"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=1fb5dca04b27614d6d04abca6f103d8d"

BRANCH:rzg2h-family = "master"
SRCREV:rzg2h-family = "ceebddab90e5ae9b100536114553af818261c660"
PV:rzg2h-family = "1.05+git${SRCPV}"
LIC_FILES_CHKSUM:rzg2h-family = "file://LICENSE.md;md5=7f62d8fc087d1e90350a140c9f8c8e99"

SRC_URI = "${FLASH_WRITER_URL};branch=${BRANCH};protocol=https"

SRC_URI:rzv2h-evk = "file://Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot"
PV:rzv2h-evk = "0.90"
LIC_FILES_CHKSUM:rzv2h-evk = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

inherit deploy
inherit nopackages
deltask do_install

# From Whinlatter (5.2) onwards, S for git sources is set automatically by
# bitbake.conf and explicitly setting S = "${WORKDIR}/git" causes an error.
# A python anonymous function is used to set S only on older Yocto versions
# (Kirkstone, Scarthgap) where UNPACKDIR does not exist and the automatic
# assignment is not present. A prebuilt image fetched as a flat file:// has no
# per-source subdirectory, so S points at UNPACKDIR or WORKDIR itself.
python () {
    if d.getVar('SRC_URI').startswith('file://'):
        d.setVar('S', d.getVar('UNPACKDIR') or d.getVar('WORKDIR'))
    elif not d.getVar('UNPACKDIR'):
        d.setVar('S', d.getVar('WORKDIR') + '/git')
}

#S = "${WORKDIR}/git"

do_compile() {
	cd ${S}

	oe_runmake BOARD=${FLASH_WRITER_BOARD}
}

do_compile:rzv2h-evk() {
	:
}

do_deploy() {
	install -d ${DEPLOYDIR}
	install -m 644 ${S}/AArch64_output/*.mot ${DEPLOYDIR}
}

do_deploy:rzv2h-evk() {
	install -d ${DEPLOYDIR}
	install -m 644 ${S}/Flash_Writer_SCIF_RZV2H_DEV_INTERNAL_MEMORY.mot ${DEPLOYDIR}
}
addtask deploy after do_compile before do_build
