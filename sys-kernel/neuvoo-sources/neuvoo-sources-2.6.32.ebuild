# Copyright 2009-2010 Neuvoo Project
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/layman/neuvoo/sys-kernel/neuvoo-sources/neuvoo-sources-9999 viridior 2010-01-11 2100EDT $

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="6"
ETYPE="sources"
inherit kernel-2 eutils
detect_version
detect_arch

KEYWORDS=""
IUSE=""
HOMEPAGE="http://neuvoo.org"
DESCRIPTION="Neuvoo Generic Kernel."

NVKV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
NVKRNL_URI="http://neuvoo.org/neuvoo/distfiles/${CATEGORY}/neuvoo-sources-${NVKV}.tar.bz2"
SRC_URI="${NVKRNL_URI} ${ARCH_URI}"

KEYWORDS="~arm"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "This ebuild for the generic neuvoo kernel."
	eifno "The following devices should work with this kernel:"
	einfo "  beagleboard, devkit800, overo, and armv7a devices"
	einfo "Please report all bugs or comments to Neuvoo Devs at:"
	einfo "IRC Freenode #neuvoo-dev or"
	einfo "${HOMEPAGE}"
}
