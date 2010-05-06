# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="OMAP Framebuffer player."
HOMEPAGE="http://git.mansr.com/?p=ffmpeg;a=summary"
SRC_URI="http://neuvoo.org/neuvoo/distfiles/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="fpu_neon"

RDEPEND="media-video/ffmpeg"
DEPEND="${RDEPEND}"

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}

pkg_postinst() {
	einfo "This ebuild is for the OMAP Framebuffer player using NEON"
	einfo "instructions. Please report all bugs or comments to its"
	einfo "developers:"
	einfo "${HOMEPAGE}"
}
