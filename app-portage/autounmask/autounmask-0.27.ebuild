# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/autounmask/autounmask-0.27.ebuild,v 1.9 2010/06/05 18:50:45 armin76 Exp $

inherit eutils

DESCRIPTION="autounmask - Unmasking packages the easy way"
HOMEPAGE="http://download.mpsna.de/opensource/autounmask/"
SRC_URI="http://download.mpsna.de/opensource/autounmask/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
		>=dev-perl/PortageXS-0.02.09
		virtual/perl-Term-ANSIColor
		dev-perl/Shell-EnvImporter"
RDEPEND="${DEPEND}
		sys-apps/portage"

src_unpack() {
	unpack "${A}" && cd "${S}" || die "failed to unpack"

	# reported to bug #323705
	epatch "${FILESDIR}/smallest-ver-only.patch" || die "failed to patch"
}

src_install() {
	dobin autounmask || die
	dodoc Changelog
}
