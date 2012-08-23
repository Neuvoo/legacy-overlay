# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
SRC_URI="http://neuvoo.org/distfiles/${PN}/${P}.tar.bz2"

inherit eutils

DESCRIPTION="Modifies portage to use a neuvoo.org squashfs image for the portage tree"
HOMEPAGE="http://neuvoo.org/"
LICENSE="BSD"
KEYWORDS="~arm"
SLOT="0"

RDEPEND="
	>=sys-apps/portage-2.2_rc67
	app-misc/realpath
"

src_unpack() {
	unpack "${A}" || die "failed to unpack"
	
	cd "${S}"
	EPATCH_SOURCE="${FILESDIR}/${PV}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch || die "failed to patch"
}

src_install() {
	cd "${S}"/etc/conf.d
	insinto /etc/conf.d
	doins squashfs-portage || die

	DESTTREE=/usr/lib/squashfs-portage dobin "${S}"/lib/bin/squashfs-portage-mount || die

	cd "${S}"/pre-sync.d/
	insinto /etc/portage/hooks/pre-sync.d
	doins 20-squashfs || die
	
	cd "${S}"/pre-run.d/
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
	elog '    besides a folder in /usr/portage. Finally, edit'
	elog '    /usr/lib/squashfs-portage/bin/squashfs-portage-mount and change the'
	elog '    following line from:'
	elog '    # for type in SQUASHFS SQUASHFS_AUFS; do'
	elog '    to:'
	elog '    # for type in SQUASHFS; do'
	elog '    In the future, aufs will be easier to disable.'
	elog
	elog 'Once this is done, run emerge --sync to get a squashfs image properly mounted'
	elog 'and ready.'
	elog
	ewarn 'Any other portage command may fail until this is done.'
}
