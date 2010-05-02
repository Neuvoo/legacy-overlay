# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# Must be before x-modular eclass is inherited
EAPI="2"
SNAPSHOT="yes"

inherit x-modular

MY_PN='xserver-xorg-video-omapfb'
MY_PV="${PV/_p/-}"
MY_PFN="${PN}_${MY_PV}.tar.gz"
SRC_URI="
	mirror://debian/pool/main/x/${PN}/${MY_PFN}
	mirror://ubuntu/pool/universe/x/${PN}/${MY_PFN}
	http://luke.dashjr.org/programs/gentoo-n8x0/distfiles/${MY_PFN}
"
DESCRIPTION="X.Org driver for TI OMAP framebuffers"
KEYWORDS="~arm"
RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/renderproto
	x11-proto/videoproto"

S="${WORKDIR}/${P/_p*/}"
IUSE="+neon"
LICENSE="as-is"

pkg_setup() {
	CONFIGURE_OPTIONS="$(use_enable neon)"
}

src_prepare() {
	epatch "${FILESDIR}"/omapfb-configure.patch
	epatch "${FILESDIR}"/omapfb-configure-xextproto.patch
	epatch "${FILESDIR}"/omapfb-driver-dpms.patch
	epatch "${FILESDIR}"/omapfb-driver-symbols.patch
	epatch "${FILESDIR}"/omapfb-driver-OMAPFBEnterVT.patch
	epatch "${FILESDIR}"/omapfb-driver-style.patch
}

src_compile() {
    ./autogen.sh || die "Auto generation of configs failed!"
	econf || die "Configure failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
