# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

inherit eutils

KEYWORDS="arm"
IUSE="install"
HOMEPAGE="http://angstrom-distribution.org"
DESCRIPTION="Beagleboard Kernel."
SLOT="0"

NV_DIST_URI="http://neuvoo.org/neuvoo/distfiles"
KRNL_URI="${NV_DIST_URI}/${PF}.bin"
MODS_URI="${NV_DIST_URI}/${PN}-modules-${PVR}.tar.gz"
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
	einfo "This kernel is for the TI Beagleboard."
	einfo "If you are not using this for a beagleboard or clones, we recommend"
	einfo "you use the generic neuvoo-sources kernel tree instead."
	einfo "Please report all bugs or comments to the Angstrom Distribution at:"
	einfo "IRC Freenode #angstrom or"
	einfo "${HOMEPAGE}"
}
