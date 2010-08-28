# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

inherit eutils

KEYWORDS="arm"
IUSE="install"
HOMEPAGE="http://openpandora.org/"
DESCRIPTION="Pandora Kernel."
SLOT="0"

NV_DIST_URI="http://neuvoo.org/neuvoo/distfiles"
KRNL_URI="${NV_DIST_URI}/${PF}.bin"
MODS_URI="${NV_DIST_URI}/${PN}-modules-${PVR}.tar.bz2"
README_URI="${NV_DIST_URI}/README_kernel"
SRC_URI="${KRNL_URI} ${MODS_URI} ${README_URI}"

pkg_setup() {
	#check if NV_KRNL_DIR set
	if [ ! "${NV_KRNL_DIR}" ]; then 
		NV_KRNL_DIR="${ROOT}/usr/lib/neuvoo/kernel"
	fi

	#check if directory exists, if not create it
	if [ -d "${NV_KRNL_DIR}" ]; then
		mkdir -p "${NV_KRNL_DIR}"
	fi
}

src_unpack() {
	cd ${DISTDIR}
	cp * "${WORKDIR}"
}

src_install() {
	insinto ${NV_KRNL_DIR}
	doins * || die "Kernel & Module Copy Failed!"
}

pkg_postinst() {
	einfo "This kernel is for the Open Pandora."
	einfo "If you are not using this for a pandora, we recommend"
	einfo "you use the generic neuvoo-sources kernel tree instead."
	einfo "Please report all bugs or comments to Open Pandora at:"
	einfo "IRC EFNET #pandora, Freenode #openpanodra, or"
	einfo "${HOMEPAGE}"
}
