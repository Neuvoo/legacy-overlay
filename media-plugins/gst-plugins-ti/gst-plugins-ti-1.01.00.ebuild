# Copyright 2009-2010 Neuvoo
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SLOT="0"
LICENSE="as-is"

inherit flag-o-matic eutils base

MY_PF="gst-ti-plugin-minimal-${PVR}"

DESCRIPTION="GStreamer DaVinci plugin for TI OMAP35xx"
HOMEPAGE="https://gstreamer.ti.com/gf/project/gstreamer_ti/"
SRC_URI="http://neuvoo.org/neuvoo/distfiles/${MY_PF}.tar.gz"

KEYWORDS="~arm"
IUSE=""
RDEPEND=">=media-libs/gstreamer-0.10.25
        >=media-libs/gst-plugins-base-0.10.25"
DEPEND="${RDEPEND}
        dev-util/pkgconfig
		sys-devel/flex"

src_unpack() {
	unpack ${A}
	cd "${MY_PF}"
}

src_compile() {
		./autogen.sh
        econf
        emake || die "emake failed."
}

src_install() {
        emake DESTDIR="${D}" install || die "emake install failed."
        dodoc [A-Z][A-Z]*
}



