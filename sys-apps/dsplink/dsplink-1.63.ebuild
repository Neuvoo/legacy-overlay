# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="OMAP 3530 DSP Link."
HOMEPAGE="http://software-dl.ti.com/dsps/dsps_registered_sw/sdo_sb/targetcontent/link/index.html"
SRC_URI="http://neuvoo.org/neuvoo/distfiles/${PF}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	source ${S}/dsplink/etc/hosts/scripts/Linux/dsplinkenv
}

src_configure() {
	#make dsplink configs
	perl ${S}/dsplink/config/bin/dsplinkcfg.pl \
	--platform=OMAP3530 --nodsp=1 \
	|| die "Perl config failed!"

	#make gpp
	cd ${S}/dsplink/gpp/src
	econf -s release || die "GPP Make failed!"

	#make dsp
	cd ${S}/dsplink/dsp/src
	econf -s release || die "DSP Make failed!"
}

src_compile() {
	emake || die "Make failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"
}

pkg_postinst() {
	einfo "This ebuild is for the OMAP Framebuffer player using NEON"
	einfo "instructions. Please report all bugs or comments to its"
	einfo "developers:"
	einfo "${HOMEPAGE}"
}
