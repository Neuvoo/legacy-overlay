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

KEYWORDS="~arm"
IUSE=""
HOMEPAGE="https://launchpad.net/gentoo-pandora-overlay"
DESCRIPTION="Git branch from the OMAP kernel devs."
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git"

src_unpack() {
	git_src_unpack
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

