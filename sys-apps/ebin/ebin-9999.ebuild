# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
EGIT_REPO_URI="git://gitorious.org/neuvoo/software.git"
EGIT_BRANCH="master"
inherit git eutils

DESCRIPTION="Auto-generates enhanced binary (ebin) ebuilds"
HOMEPAGE="http://neuvoo.org/"
LICENSE="BSD"
KEYWORDS=""
SLOT="0"

RDEPEND="
	>=sys-apps/portage-9999
	app-misc/realpath
"

src_install() {
	cd "${S}"/ebin/etc/conf.d
	insinto /etc/conf.d
	doins ebin || die

	DESTTREE=/usr/lib/ebin dobin "${S}"/ebin/usr/lib/ebin/bin/ebin || die

	cd "${S}"/ebin/etc/portage/hooks/post-ebuild.d/
	insinto /etc/portage/hooks/post-ebuild.d
	doins 80-ebin || die
	
	ewarn 'ebin is EXPERIMENTAL software, and not yet intended for production use!'
}
