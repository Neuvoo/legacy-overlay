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
	
	cd "${S}"/squashfs-portage/pre-run.d/
	insinto /etc/portage/hooks/pre-run.d
	doins 20-squashfs || die
	
	elog
	elog 'Before portage will sync the following must be done:'
	elog ' *) Review /etc/conf.d/squashfs-portage and create the SQUASHFS_BASEDIR'
	elog '    and SQUASHFS_MOUNT files, like so:'
	elog '    # mkdir -p ${SQUASHFS_BASEDIR}'
	elog '    # mkdir -p ${SQUASHFS_MOUNT}'
	elog ' *) Add FEATURES="hooks" to /etc/make.conf.'
	elog ' *) Verify at least squashfs support is enabled in the kernel. If you do'
	elog '    not have aufs as well, change SQUASHFS_MOUNT to '"'"'/usr/portage'"'"' and'
	elog '    in /etc/make.conf configure PKGDIR and DISTDIR to point somewhere'
	elog '    besides a folder in /usr/portage. In the future, aufs will be easier to'
	elog '    disable.'
	elog
	elog 'Once this is done, run emerge --sync to get a squashfs image properly mounted'
	elog 'and ready.'
	elog
	ewarn 'Any other portage command may fail until this is done.'
}
