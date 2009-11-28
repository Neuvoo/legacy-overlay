# Neuvoo.org
# Distributed under the terms of the GNU General Public License v2
# $Header: created by viridior 2009-08-31 1000EDT $

inherit eutils
SLOT="0"

KEYWORDS="x86 ~x86 arm ~arm"
HOMEPAGE="http://neuvoo.org"
DESCRIPTION="Neuvoo desktop configs."
SRC_URI="http://neuvoo.org/gentoo/distfiles/${P}.tar.bz2"

src_compile() {
	into /etc
}

pkg_postinst() {
	einfo "You have emerged the Neuvoo desktop configs..."
	einfo "Establish /etc/make.conf if not already set."
	einfo "	 execute: $dispatch-conf"
	einfo "For more info and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
