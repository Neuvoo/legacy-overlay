# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
EGIT_REPO_URI="git://gitorious.org/neuvoo/software.git"
EGIT_BRANCH="master"
inherit git eutils

DESCRIPTION="Modifies portage to use a neuvoo.org squashfs image for the portage tree"
HOMEPAGE="http://neuvoo.org/"
LICENSE="BSD"
KEYWORDS=""
SLOT="0"

RDEPEND="
	>=sys-apps/portage-9999
	app-misc/realpath
"

src_install() {
	cd "${S}"/squashfs-portage/etc/conf.d
	insinto /etc/conf.d
	doins squashfs-portage || die

	DESTTREE=/usr/lib/squashfs-portage dobin "${S}"/squashfs-portage/lib/bin/squashfs-portage-mount || die

	cd "${S}"/squashfs-portage/pre-sync.d/
	insinto /etc/portage/hooks/pre-sync.d
	doins 20-squashfs || die
	
	elog
	elog "Before portage will sync, review /etc/conf.d/squashfs-portage and create the"
	elog "SQUASHFS_BASEDIR and SQUASHFS_MOUNT files, like so:"
	elog '# mkdir -p $SQUASHFS_BASEDIR}'
	elog '# mkdir -p ${SQUASHFS_MOUNT}'
	elog
	elog "Run emerge --sync after to get a squashfs image."
#	ewarn "Any other portage command may fail until this is done." # not yet it won't, until other hooks are implemented.
}
