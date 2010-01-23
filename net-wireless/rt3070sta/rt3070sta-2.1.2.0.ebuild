# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: net-wireless/rt3070 viridior 2010-01-22 1900EDT $

inherit eutils linux-mod

DESCRIPTION="Driver for the RaLink RT3070 USB wireless chipsets"
HOMEPAGE="http://www.ralinktech.com/support.php?s=2"
LICENSE="GPL-2"

RESTRICT="nomirror"

MY_P="2009_1110_RT3070_Linux_STA_v${PV}"

SRC_URI="http://neuvoo.org/neuvoo/distfiles/${MY_P}.tar.bz2"

KEYWORDS="arm"
IUSE="debug"
SLOT="0"

DEPEND=""
RDEPEND="net-wireless/wireless-tools"

S="${WORKDIR}/${MY_P}"
MODULE_NAMES="rt3070sta(net:${S}/os/linux)"
#BUILD_TARGETS=" "
MODULESD_RT3070_ALIASES=('ra? rt3070')

CONFIG_CHECK="WIRELESS_EXT"
ERROR_WIRELESS_EXT="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_WIRELESS_EXT)."

src_unpack() {
	epatch ${FILESDIR}/config.patch
	epatch ${FILESDIR}/makefile.patch
}

src_compile() {
	cd "${S}"
	if kernel_is 2 6; then
		cp os/linux/Makefile.6 os/linux/Makefile
	elif kernel_is 2 4; then
		cp os/linux/Makefile.4 os/linux/Makefile
	else
		die "Your kernel version is not supported!"
	fi
	myarch=${ARCH}
	unset ARCH
	emake || die "make failed"
	ARCH=${myarch}
	#linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	dodoc README_STA iwpriv_usage.txt
	insinto /etc/Wireless/RT3070STA
	insopts -m 0600
	doins RT3070STA.dat
	insopts -m 0644
	doins common/rt3070.bin
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo
	einfo "Visit RaLink for support."
	einfo "${HOMEPAGE}"
	einfo
}
