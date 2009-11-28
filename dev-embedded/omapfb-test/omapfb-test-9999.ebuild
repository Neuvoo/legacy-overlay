# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EGIT_PATCHES="${FILESDIR}/${P}-cross.patch"

inherit linux-info git

DESCRIPTION="omapfb test utils"
HOMEPAGE="http://gitorious.org/linux-omap-dss2/omapfb-tests"

EGIT_REPO_URI="git://gitorious.org/linux-omap-dss2/${PN}.git"

LICENSE="GPL"
SLOT="0"
KEYWORDS="arm ~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	git_src_prepare
	cd "${S}"
	sed -i -e "s:\/home\/valkeine\/work\/linux:${KV_DIR}:" Makefile \
		        || die "sed fix failed. Uh-oh..."
}
