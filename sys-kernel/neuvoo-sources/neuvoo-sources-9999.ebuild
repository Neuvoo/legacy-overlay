# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/layman/neuvoo/sys-kernel/neuvoo-sources/neuvoo-sources-9999 viridior 2010-01-11 2100EDT $

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
HOMEPAGE="http://neuvoo.org"
DESCRIPTION="Neuvoo Development Kernel."
EGIT_REPO_URI="git://gitorious.org/neuvoo/kernel.git"
EGIT_BRANCH="dev"

src_unpack() {
	git_src_unpack
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "This ebuild for the neuvoo development kernel."
	einfo "Please report all bugs or comments to Neuvoo Devs at:"
	einfo "IRC Freenode #neuvoo-dev or"
	einfo "${HOMEPAGE}"
}
