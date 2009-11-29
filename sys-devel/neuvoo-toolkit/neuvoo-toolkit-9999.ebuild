# Neuvoo.org
# Distributed under the terms of the GNU General Public License v2
# $Header: created by viridior 2009-11-28 2211GMT $

inherit eutils git
SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ~x86 arm ~arm"
HOMEPAGE="http://neuvoo.org"
DESCRIPTION="Neuvoo Toolkit."
EGIT_REPO_URI="git://gitorious.org/neuvoo/toolkit.git"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	git_src_prepare
}

src_compile() {
	into /opt/${PN}
}

src_install() {
        local dirs="bin build env"
        dodoc HOWTO || die "Failed to install documentation"
        insinto "/opt/${P}"
        doins -r bin/ env/ || die "Failed to install data"
}

pkg_postinst() {
	einfo "Make sure to read the HOWTO or visit:"
	einfo "${HOMEPAGE}"
}
