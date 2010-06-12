# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: viridior $

EAPI="2"

inherit eutils flag-o-matic multilib toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.openpandora.org/pandora-libraries.git"
	inherit git
	KEYWORDS=""
else
	SRC_URI="http://neuvoo.org/neuvoo/distfiles/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="libpnd is a basic collection of functions and tools to make working Pandora-specific operations easier."
HOMEPAGE="http://pandorawiki.org/Libpnd_hub"

LICENSE="LGPL"
SLOT="0"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-gfx"
DEPEND="${RDEPEND}"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${A}
	fi
	cd "./pandora-libraries/"
}

src_compile() {
	tc-export CC AR RANLIB
	emake || die "emake failed!"
	emake deploy || die "emake deploy failed!"
}

src_install() {
	# install docs
	dodoc CHANGES *.txt

	# install deployment packages to root
	cd "./deployment"
	cp -Rpv "." "${D}/"
	cd ..

	# make follow on directories
	dodir /mnt/pnd
	dodir /mnt/utmp
}

pkg_postinst() {
	elog "The libpnd ebuild is provided as a convience by the Neuvoo Project."
	elog "Bug reports outside of the ebuild installation should be reported"
	elog "directly to the libpnd maintainers found at their website:"
	elog "${HOMEPAGE}"
}
