# Neuvoo.org
# Distributed under the terms of the GNU General Public License v2
# $Header: created by viridior 2009-08-30 1000EDT $

inherit eutils
SLOT="0"

KEYWORDS="x86 ~x86 arm ~arm"
HOMEPAGE="http://neuvoo.org"
DESCRIPTION="Neuvoo system tools."
SRC_URI="http://neuvoo.org/gentoo/distfiles/${P}.tar.bz2"

DEPEND=""

src_compile() {
	into /usr/bin
}

pkg_postinst() {
	einfo "You have emerged the Neuvoo system tools..."
	einfo "For more info and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
