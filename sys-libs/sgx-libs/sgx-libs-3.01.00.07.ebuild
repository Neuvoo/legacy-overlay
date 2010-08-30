# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

inherit eutils

EAPI="2"
KEYWORDS="arm"
IUSE="openes-v2 openes-v3 openes-v5"
HOMEPAGE="http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/gfxsdk/latest/index_FDS.html"
DESCRIPTION="TI OMAP SGX Libraries."
SLOT="0"
LICENSE="TI"

NV_DIST_URI="http://neuvoo.org/neuvoo/distfiles"
PKG_URI="${NV_DIST_URI}/SGX-${PVR}-libs.tar.gz"
INIT_URI="${NV_DIST_URI}/sgx-init.sh"
SRC_URI="${PKG_URI} ${INIT_URI}"
PKG_TARBALL="target_libs.tar.gz"

src_unpack() {
	unpack ${A}
	cp "${DISTDIR}/sgx-init.sh" "${WORKDIR}/sgx"
}

src_prepare() {
	cd ${WORKDIR}

	#only unpack from target_libs.tar.gz the libs we want
	if use openes-v2; then
	tar -xvz --wildcards -f ${PKG_TARBALL} *ES2*
	fi

	if use openes-v3; then
	tar -xvz --wildcards -f ${PKG_TARBALL} *ES3*
	fi

	if use openes-v5; then
	tar -xvz --wildcards -f ${PKG_TARBALL} *ES5*
	fi
}

src_install() {
	into /
	cp -R "${WORKDIR}/usr/" "${D}" || die "Install Copy Failed!"
	dodir /etc/init.d/
	cp "${WORKDIR}/sgx" "${D}/etc/init.d/sgx" || die "Install initscript Failed!"
}

pkg_postinst() {
	einfo "The SGX Drivers/Tools were developed by Texas Intruments and are provided to users"
	einfo "as a convenience.  This resource is only intended for the OMAP3/4 based"
	einfo "processors with OPENGL ES. Please report all bugs or comments to Texas Instruments at:"
	einfo "${HOMEPAGE}"
}
