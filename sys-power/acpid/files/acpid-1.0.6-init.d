#!/sbin/runscript
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpid/files/acpid-1.0.6-init.d,v 1.3 2009/01/19 04:48:49 vapier Exp $

opts="reload"

depend() {
	need localmount
	use logger
	before hald
}

checkconfig() {
	if [ ! -e /proc/acpi ] ; then
		eerror "ACPI support has not been compiled into the kernel"
		return 1
	fi
}

start() {
	checkconfig || return 1

	ebegin "Starting acpid"
	start-stop-daemon --start --quiet --exec /usr/sbin/acpid -- ${ACPID_OPTIONS}
	eend $?
}

stop() {
	ebegin "Stopping acpid"
	start-stop-daemon --stop --exec /usr/sbin/acpid
	eend $?
}

reload() {
	ebegin "Reloading acpid configuration"
	start-stop-daemon --stop --oknodo --exec /usr/sbin/acpid --signal HUP
	eend $?
}
