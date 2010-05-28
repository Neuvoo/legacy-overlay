# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-9999.ebuild,v 1.4 2010/04/28 07:26:51 zmedico Exp $

# Require EAPI 2 since we now require at least python-2.6 (for python 3
# syntax support) which also requires EAPI 2.
EAPI=2
EGIT_REPO_URI="git://gitorious.org/neuvoo/software.git"
EGIT_BRANCH="master"
inherit git eutils

DESCRIPTION="Modifies portage to use a neuvoo.org squashfs image for the portage tree"
HOMEPAGE="http://neuvoo.org/"
LICENSE="BSD"
KEYWORDS=""
SLOT="0"

RDEPEND=(
	">=sys-apps/portage-9999"
)

src_install() {
	cd "${S}"/hooks/pre-sync.d/
	insinto /etc/portage/hooks/pre-sync.d
	doins 20-squashfs || die
	
	elog
	elog "Run emerge --sync to get a squashfs image."
#	elog "Any other portage command may fail until this is done." # not yet it won't, until other hooks are implemented.
	elog
}
