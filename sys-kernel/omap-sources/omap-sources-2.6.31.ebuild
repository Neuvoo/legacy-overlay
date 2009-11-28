# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/layman/pandora/sys-kernel/pandora-git-sources/pandora-git-sources-9999 viridior 2009-08-10 1800EDT $

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
ETYPE="sources"
inherit kernel-2 eutils git
detect_version
detect_arch

KEYWORDS=""
IUSE=""
HOMEPAGE="http://openembedded.org"
DESCRIPTION="Openembedded Kernel patches applied to the OMAP kernel."
EGIT_REPO_URI="git://gitorious.org/gentoo-arm-overlay/gentoo-omap-sources.git"
EGIT_BRANCH="oe/stable/2.6.31"
#EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git"
#EGIT_TREE="fd673394fa970fb82e4bc206e171c58995d0c2ba"
#EGIT_STORE_DIR="linux-omap-2.6.29"

src_unpack() {
	git_src_unpack
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "This ebuild tracks OE kernel 2.6.29-r41. Thanks to OE dev team for all the patches"
	einfo "${HOMEPAGE}"
}

