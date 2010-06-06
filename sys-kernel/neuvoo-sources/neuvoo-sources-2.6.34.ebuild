# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git"

inherit git

SLOT="${PV}"
KEYWORDS="~arm"
IUSE=""
HOMEPAGE="http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=summary"
DESCRIPTION="Linux OMAP 2.6 kernel"

src_compile() {
}

src_install() {
	insinto /usr/src/"${P}"
	doinst -r "${S}"/*
}
