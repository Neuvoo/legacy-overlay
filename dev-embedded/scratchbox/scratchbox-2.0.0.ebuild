# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Cross-compilation engine for creation of highly flexible SDKs"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/sbox2"
SRC_URI="http://people.freedesktop.org/~lle/sbox2-releases/sbox2-2.0.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/sbox2-${PV}"

src_compile() {
    autoreconf -f -i || die "autoreconf failed"
    econf || die "econf failed"
    emake || die "emake failed"
}

src_install() {
    emake prefix="${D}/usr/" install || die "make install failed"
    dodoc AUTHORS LICENSE README TODO || die "dodoc failed"
    doman docs/*.1 || die "doman failed"
}

