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

#src_install() {
##	local dirs="bin build env"
#
#	dodir /opt/${PN}
#	cp -pPR bin "/opt/${PN}/" || die "Failed to copy."
#
#	insinto /opt/${PN}
#	doins HOWTO
#
#}

src_compile() {
	into /opt/${PN}
}

pkg_postinst() {
	einfo "You have emerged the Neuvoo Toolkit..."
	einfo "Make sure to read the HOWTO or visit:"
	einfo "${HOMEPAGE}"
}
