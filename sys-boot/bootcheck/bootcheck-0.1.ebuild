# Copyright (c) 2009 Jacob Godserv <fun2program8@yahoo.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

EAPI="2"

DESCRIPTION="a simple questionnaire that runs if certain things haven't been configured yet."
HOMEPAGE="http://gentoo.openpandora.org/"

SLOT="0"
KEYWORDS="~x86"
SRC_URI="http://gentoo-pandora.org/portage/distfiles/${PN}-${PV}.tar.bz2"
LICENSE="BSD"

src_install() {
	find "${S}" -mindepth 1 -maxdepth 1 -exec cp -vR '{}' "${D}/" \; || die "Install failed!"
}

pkg_postinst() {
	elog "The bootcheck init script has been installed, but it should be put"
	elog "into the boot runlevel. You can do so by running the following"
	elog "command:"
	elog "# rc-update add bootcheck boot"
}
