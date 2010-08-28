# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

inherit eutils

KEYWORDS="arm"
IUSE="install"
HOMEPAGE="http://www.open-pandora.org"
DESCRIPTION="Pandora U-Boot."
SLOT="0"

NV_DIST_URI="http://neuvoo.org/neuvoo/distfiles"
UBOOT_URI="${NV_DIST_URI}/${PF}.tar.bz2"
README_URI="${NV_DIST_URI}/README_uboot"
SRC_URI="${UBOOT_URI} ${README_URI}"

pkg_setup() {
	#check if NV_UBOOT_DIR set
	if [ ! "${NV_UBOOT_DIR}" ]; then 
		NV_UBOOT_DIR="${ROOT}/usr/lib/neuvoo/u-boot"
	fi

	#check if directory exists, if not create it
	if [ -d "${NV_UBOOT_DIR}" ]; then
		mkdir -p "${NV_UBOOT_DIR}"
	fi
}

src_unpack() {
	cd ${DISTDIR}
	cp * "${WORKDIR}"
}

src_install() {
	insinto ${NV_UBOOT_DIR}
	doins * || die "U-Boot Copy Failed!"
}

pkg_postinst() {
	einfo "These u-boot files are for the Open Pandora."
	einfo "If you are not using these files for a pandora, we recommend"
	einfo "you use the device specific u-boot files instead."
	einfo "Please report all bugs or comments to Open Pandora at:"
	einfo "IRC EFNet #pandora, Freenode #openpandora, or"
	einfo "${HOMEPAGE}"
}
