# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/layman/pandora/sys-kernel/pandora-git-sources/pandora-git-sources-9999 viridior 2009-08-10 1800EDT $

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
ETYPE="sources"
#KV="omap-git"
# only use this if it's not an _rc/_pre release
#[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2 eutils git
detect_version
detect_arch

KEYWORDS=""
IUSE=""
HOMEPAGE="git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git"
DESCRIPTION="Live ebuild of the upstream OMAP kernel"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git"

src_unpack() {
	git_src_unpack
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "${HOMEPAGE}"
}

