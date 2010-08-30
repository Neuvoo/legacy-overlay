# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

inherit eutils

EAPI="2"
KEYWORDS="arm"
IUSE=""
HOMEPAGE="http://www.omappedia.org/wiki/DSPBridge_Project"
DESCRIPTION="TI OMAP DSP Libraries."
SLOT="0"
LICENSE="TI"

NV_DIST_URI="http://neuvoo.org/neuvoo/distfiles"
PKG_URI="${NV_DIST_URI}/DSP_Install_libs-${PVR}.tar.gz"
INIT_URI="${NV_DIST_URI}/dsp-init.sh"
SRC_URI="${PKG_URI} ${INIT_URI}"
PKG_TARBALL="dsp_libs.tar.gz"

src_unpack() {
	unpack ${A}
	cp "${DISTDIR}/dsp-init.sh" "${WORKDIR}/dsp"
}

src_prepare() {
	cd ${WORKDIR}
	tar -xvzf ${PKG_TARBALL}
}

src_install() {
	into /
	cp -R "${WORKDIR}/{lib,opt}/" "${D}" || die "Install Copy Failed!"
	dodir /etc/init.d/
	cp "${WORKDIR}/dsp" "${D}/etc/init.d/dsp" || die "Install initscript Failed!"
}

pkg_postinst() {
	einfo "The DSP Drivers/Tools were developed by Texas Intruments and are provided to users"
	einfo "as a convenience.  This resource is only intended for the OMAP1/2/3/4 based"
	einfo "processors. Please report all bugs or comments to Texas Instruments at:"
	einfo "${HOMEPAGE}"
}
