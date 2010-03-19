# Copyright 2010 Always Innovating, http://alwaysinnovating.com/
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/layman/neuvoo/sys-kernel/touchbook-sources/touchbook-sources-201001b viridior 2010-01-22 1900EDT $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
ETYPE="sources"
inherit kernel-2 eutils
detect_version
detect_arch

KEYWORDS=""
IUSE=""
HOMEPAGE="http://alwaysinnovating.com"
DESCRIPTION="Always Innovating Touchbook Kernel."

SRC_URI="http://www.alwaysinnovating.com/release/2010-01.b/uImage"

KEYWORDS="arm"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "This kernel is for the Always Innovating Touchbook."
	eifno "If you are not using this for a touchbook, we recommend"
	einfo "you use the generic neuvoo-sources kernel tree instead."
	einfo "Please report all bugs or comments to Always Innovating at:"
	einfo "IRC Freenode #touchbook or"
	einfo "${HOMEPAGE}"
}
