# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-9999.ebuild,v 1.40 2011/12/22 04:46:55 zmedico Exp $

EAPI=3
inherit git-2 eutils multilib python

DESCRIPTION="Portage is the package management and distribution system for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="build doc epydoc +ipc python2 python3 selinux xattr"

# Import of the io module in python-2.6 raises ImportError for the
# thread module if threading is disabled.
python_dep="python3? ( =dev-lang/python-3* )
	!python2? ( !python3? (
		build? ( || ( dev-lang/python:2.7 dev-lang/python:2.6[threads] ) )
		!build? ( || ( dev-lang/python:2.7 dev-lang/python:2.6[threads] >=dev-lang/python-3 ) )
	) )
	python2? ( !python3? ( || ( dev-lang/python:2.7 dev-lang/python:2.6[threads] ) ) )"

# The pysqlite blocker is for bug #282760.
DEPEND="${python_dep}
	!build? ( >=sys-apps/sed-4.0.5 )
	doc? ( app-text/xmlto ~app-text/docbook-xml-dtd-4.4 )
	epydoc? ( >=dev-python/epydoc-2.0 !<=dev-python/pysqlite-2.4.1 )"
# Require sandbox-2.2 for bug #288863.
# For xattr, we can spawn getfattr and setfattr from sys-apps/attr, but that's
# quite slow, so it's not considered in the dependencies as an alternative to
# to python-3.3 / pyxattr. Also, xattr support is only tested with Linux, so
# for now, don't pull in xattr deps for other kernels.
RDEPEND="${python_dep}
	!build? ( >=sys-apps/sed-4.0.5
		>=app-shells/bash-3.2_p17
		>=app-admin/eselect-1.2 )
	elibc_FreeBSD? ( sys-freebsd/freebsd-bin )
	elibc_glibc? ( >=sys-apps/sandbox-2.2 )
	elibc_uclibc? ( >=sys-apps/sandbox-2.2 )
	>=app-misc/pax-utils-0.1.17
	xattr? ( kernel_linux? ( || ( >=dev-lang/python-3.3_pre20110902 dev-python/pyxattr ) ) )
	selinux? ( || ( >=sys-libs/libselinux-2.0.94[python] <sys-libs/libselinux-2.0.94 ) )
	!<app-shells/bash-3.2_p17
	!<app-admin/logrotate-3.8.0"
PDEPEND="
	!build? (
		>=net-misc/rsync-2.6.4
		userland_GNU? ( >=sys-apps/coreutils-6.4 )
	)"
# coreutils-6.4 rdep is for date format in emerge-webrsync #164532
# NOTE: FEATURES=install-sources requires debugedit and rsync

SRC_ARCHIVES="http://dev.gentoo.org/~zmedico/portage/archives"

prefix_src_archives() {
	local x y
	for x in ${@}; do
		for y in ${SRC_ARCHIVES}; do
			echo ${y}/${x}
		done
	done
}

# Gentoo bug #272988
EGIT_REPO_URI="git://github.com/Neuvoo/portage.git"
EGIT_BRANCH="neuvoo/trunk"
S="${WORKDIR}"/${PN}

compatible_python_is_selected() {
	[[ $(/usr/bin/python -c 'import sys ; sys.stdout.write(sys.hexversion >= 0x2060000 and "good" or "bad")') = good ]]
}

pkg_setup() {
	# Bug #359731 - Die early if get_libdir fails.
	[[ -z $(get_libdir) ]] && \
		die "get_libdir returned an empty string"

	if use python2 && use python3 ; then
		ewarn "Both python2 and python3 USE flags are enabled, but only one"
		ewarn "can be in the shebangs. Using python3."
	fi
	if ! use python2 && ! use python3 && ! compatible_python_is_selected ; then
		ewarn "Attempting to select a compatible default python interpreter"
		local x success=0
		for x in /usr/bin/python2.* ; do
			x=${x#/usr/bin/python2.}
			if [[ $x -ge 6 ]] 2>/dev/null ; then
				eselect python set python2.$x
				if compatible_python_is_selected ; then
					elog "Default python interpreter is now set to python-2.$x"
					success=1
					break
				fi
			fi
		done
		if [ $success != 1 ] ; then
			eerror "Unable to select a compatible default python interpreter!"
			die "This version of portage requires at least python-2.6 to be selected as the default python interpreter (see \`eselect python --help\`)."
		fi
	fi

	if use python3; then
		python_set_active_version 3
	elif use python2; then
		python_set_active_version 2
	fi
}

src_prepare() {
	#local _version=$(cd "${S}/.git" && git describe --tags | sed -e 's|-\([0-9]\+\)-.\+$|_p\1|')
	#_version=${_version:1}
	local _version="9999"
	einfo "Setting portage.VERSION to ${_version} ..."
	sed -e "s/^VERSION=.*/VERSION='${_version}'/" -i pym/portage/__init__.py || \
		die "Failed to patch portage.VERSION"
	sed -e "1s/VERSION/${_version}/" -i doc/fragment/version || \
		die "Failed to patch VERSION in doc/fragment/version"
	sed -e "1s/VERSION/${_version}/" -i man/* || \
		die "Failed to patch VERSION in man page headers"

	if ! use ipc ; then
		einfo "Disabling ipc..."
		sed -e "s:_enable_ipc_daemon = True:_enable_ipc_daemon = False:" \
			-i pym/_emerge/AbstractEbuildProcess.py || \
			die "failed to patch AbstractEbuildProcess.py"
	fi

	if use xattr && use kernel_linux ; then
		einfo "Adding FEATURES=xattr to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} xattr"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi

	if use python3; then
		einfo "Converting shebangs for python3..."
		python_convert_shebangs -r 3 .
	elif use python2; then
		einfo "Converting shebangs for python2..."
		python_convert_shebangs -r 2 .
	fi

	if [[ -n ${EPREFIX} ]] ; then
		einfo "Setting portage.const.EPREFIX ..."
		sed -e "s|^\(SANDBOX_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/sandbox\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(FAKEROOT_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/bin/fakeroot\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(BASH_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/bash\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(MOVE_BINARY[[:space:]]*=[[:space:]]*\"\)\(/bin/mv\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(PRELINK_BINARY[[:space:]]*=[[:space:]]*\"\)\(/usr/sbin/prelink\"\)|\\1${EPREFIX}\\2|" \
			-e "s|^\(EPREFIX[[:space:]]*=[[:space:]]*\"\).*|\\1${EPREFIX}\"|" \
			-i pym/portage/const.py || \
			die "Failed to patch portage.const.EPREFIX"

		einfo "Prefixing shebangs ..."
		find . -type f -print0 | \
		while read -r -d $'\0' ; do
			local shebang=$(head -n1 "$REPLY")
			if [[ ${shebang} == "#!"* && ! ${shebang} == "#!${EPREFIX}/"* ]] ; then
				sed -i -e "1s:.*:#!${EPREFIX}${shebang:2}:" "$REPLY" || \
					die "sed failed"
			fi
		done

		einfo "Adjusting make.globals ..."
		sed -e 's|^SYNC=.*|SYNC="rsync://rsync.prefix.freens.org/gentoo-portage-prefix"|' \
			-e "s|^\(PORTDIR=\)\(/usr/portage\)|\\1\"${EPREFIX}\\2\"|" \
			-e "s|^\(PORTAGE_TMPDIR=\)\(/var/tmp\)|\\1\"${EPREFIX}\\2\"|" \
			-i cnf/make.globals || die "sed failed"

		einfo "Adding FEATURES=force-prefix to make.globals ..."
		echo -e '\nFEATURES="${FEATURES} force-prefix"' >> cnf/make.globals \
			|| die "failed to append to make.globals"
	fi
}

src_compile() {
	if use doc; then
		cd "${S}"/doc
		touch fragment/date
		make xhtml xhtml-nochunks || die "failed to make docs"
	fi

	if use epydoc; then
		einfo "Generating api docs"
		mkdir "${WORKDIR}"/api
		local my_modules epydoc_opts=""
		my_modules="$(find "${S}/pym" -name "*.py" \
			| sed -e 's:/__init__.py$::' -e 's:\.py$::' -e "s:^${S}/pym/::" \
			 -e 's:/:.:g' | sort)" || die "error listing modules"
		# workaround for bug 282760
		> "$S/pym/pysqlite2.py"
		PYTHONPATH=${S}/pym:${PYTHONPATH:+:}${PYTHONPATH} \
			epydoc -o "${WORKDIR}"/api \
			-qqqqq --no-frames --show-imports $epydoc_opts \
			--name "${PN}" --url "${HOMEPAGE}" \
			${my_modules} || die "epydoc failed"
		rm "$S/pym/pysqlite2.py"
	fi
}

src_test() {
	./runtests.sh || die "tests failed"
}

src_install() {
	local libdir=$(get_libdir)
	local portage_base="/usr/${libdir}/portage"
	local portage_share_config=/usr/share/portage/config

	cd "${S}"/cnf
	insinto /etc
	doins etc-update.conf dispatch-conf.conf || die

	insinto "$portage_share_config/sets"
	doins "$S"/cnf/sets/*.conf || die
	insinto "$portage_share_config"
	doins "$S/cnf/make.globals" || die
	if [ -f "make.conf.${ARCH}".diff ]; then
		patch make.conf "make.conf.${ARCH}".diff || \
			die "Failed to patch make.conf.example"
		newins make.conf make.conf.example || die
	else
		eerror ""
		eerror "Portage does not have an arch-specific configuration for this arch."
		eerror "Please notify the arch maintainer about this issue. Using generic."
		eerror ""
		newins make.conf make.conf.example || die
	fi

	dosym ..${portage_share_config}/make.globals /etc/make.globals

	insinto /etc/logrotate.d
	doins "${S}"/cnf/logrotate.d/elog-save-summary || die

	# BSD and OSX need a sed wrapper so that find/xargs work properly
	if use userland_GNU; then
		rm "${S}"/bin/ebuild-helpers/sed || die "Failed to remove sed wrapper"
	fi

	local x symlinks files

	cd "$S" || die "cd failed"
	for x in $(find bin -type d) ; do
		exeinto $portage_base/$x || die "exeinto failed"
		cd "$S"/$x || die "cd failed"
		files=$(find . -mindepth 1 -maxdepth 1 -type f ! -type l)
		if [ -n "$files" ] ; then
			doexe $files || die "doexe failed"
		fi
		symlinks=$(find . -mindepth 1 -maxdepth 1 -type l)
		if [ -n "$symlinks" ] ; then
			cp -P $symlinks "${ED}$portage_base/$x" || die "cp failed"
		fi
	done

	cd "$S" || die "cd failed"
	for x in $(find pym/* -type d ! -path "pym/portage/tests*") ; do
		insinto $portage_base/$x || die "insinto failed"
		cd "$S"/$x || die "cd failed"
		# __pycache__ directories contain no py files
		[[ "*.py" != $(echo *.py) ]] || continue
		doins *.py || die "doins failed"
		symlinks=$(find . -mindepth 1 -maxdepth 1 -type l)
		if [ -n "$symlinks" ] ; then
			cp -P $symlinks "${ED}$portage_base/$x" || die "cp failed"
		fi
	done

	# We install some minimal tests for use as a preinst sanity check.
	# These tests must be able to run without a full source tree and
	# without relying on a previous portage instance being installed.
	cd "$S" || die "cd failed"
	exeinto $portage_base/pym/portage/tests || die
	doexe pym/portage/tests/runTests || die
	insinto $portage_base/pym/portage/tests || die
	doins pym/portage/tests/*.py || die
	insinto $portage_base/pym/portage/tests/lint || die
	doins pym/portage/tests/lint/*.py || die
	doins pym/portage/tests/lint/__test__ || die

	# Symlinks to directories cause up/downgrade issues and the use of these
	# modules outside of portage is probably negligible.
	for x in "${ED}${portage_base}/pym/"{cache,elog_modules} ; do
		[ ! -L "${x}" ] && continue
		die "symlink to directory will cause upgrade/downgrade issues: '${x}'"
	done

	doman "${S}"/man/*.[0-9]

	echo 'Producing ChangeLog from Git history...'
	( cd "${S}/.git" && git log > "${S}"/ChangeLog )
	dodoc "${S}"/{ChangeLog,NEWS,RELEASE-NOTES} || die 'dodoc failed'
	use doc && dohtml -r "${S}"/doc/*
	use epydoc && dohtml -r "${WORKDIR}"/api

	dodir /usr/bin
	for x in ebuild egencache emerge portageq quickpkg repoman ; do
		dosym ../${libdir}/portage/bin/${x} /usr/bin/${x}
	done

	dodir /usr/sbin
	local my_syms="archive-conf
		dispatch-conf
		emaint
		emerge-webrsync
		env-update
		etc-update
		fixpackages
		regenworld"
	local x
	for x in ${my_syms}; do
		dosym ../${libdir}/portage/bin/${x} /usr/sbin/${x}
	done
	dosym env-update /usr/sbin/update-env
	dosym etc-update /usr/sbin/update-etc

	dodir /etc/portage
	keepdir /etc/portage
}

pkg_preinst() {
	if [[ $ROOT == / ]] ; then
		# Run some minimal tests as a sanity check.
		local test_runner=$(find "${ED}" -name runTests)
		if [[ -n $test_runner && -x $test_runner ]] ; then
			einfo "Running preinst sanity tests..."
			"$test_runner" || die "preinst sanity tests failed"
		fi
	fi

	if ! use build && ! has_version dev-python/pycrypto && \
		! has_version '>=dev-lang/python-2.6[ssl]' ; then
		ewarn "If you are an ebuild developer and you plan to commit ebuilds"
		ewarn "with this system then please install dev-python/pycrypto or"
		ewarn "enable the ssl USE flag for >=dev-lang/python-2.6 in order"
		ewarn "to enable RMD160 hash support."
		ewarn "See bug #198398 for more information."
	fi
	if [ ! -L "${EROOT}/etc/make.globals" ]; then
		rm -f "${EROOT}/etc/make.globals"
	fi

	has_version "<${CATEGORY}/${PN}-2.2_alpha" \
		&& MINOR_UPGRADE=true || MINOR_UPGRADE=false

	has_version "<=${CATEGORY}/${PN}-2.2_pre5" \
		&& WORLD_MIGRATION_UPGRADE=true || WORLD_MIGRATION_UPGRADE=false

	# If portage-2.1.6 is installed and the preserved_libs_registry exists,
	# assume that the NEEDED.ELF.2 files have already been generated.
	has_version "<=${CATEGORY}/${PN}-2.2_pre7" && \
		! ( [ -e "${EROOT}"var/lib/portage/preserved_libs_registry ] && \
		has_version ">=${CATEGORY}/${PN}-2.1.6_rc" ) \
		&& NEEDED_REBUILD_UPGRADE=true || NEEDED_REBUILD_UPGRADE=false

	[[ -n $PORTDIR_OVERLAY ]] && has_version "<${CATEGORY}/${PN}-2.1.6.12" \
		&& REPO_LAYOUT_CONF_WARN=true || REPO_LAYOUT_CONF_WARN=false
}

pkg_postinst() {
	# Compile all source files recursively. Any orphans
	# will be identified and removed in postrm.
	python_mod_optimize /usr/$(get_libdir)/portage/pym

	if $WORLD_MIGRATION_UPGRADE ; then
		einfo "moving set references from the worldfile into world_sets"
		cd "${EROOT}/var/lib/portage/"
		grep "^@" world >> world_sets
		sed -i -e '/^@/d' world
	fi

	if $NEEDED_REBUILD_UPGRADE ; then
		einfo "rebuilding NEEDED.ELF.2 files"
		for cpv in "${EROOT}/var/db/pkg"/*/*; do
			if [ -f "${cpv}/NEEDED" ]; then
				rm -f "${cpv}/NEEDED.ELF.2"
				while read line; do
					filename=${line% *}
					needed=${line#* }
					needed=${needed//+/++}
					needed=${needed//#/##}
					needed=${needed//%/%%}
					newline=$(scanelf -BF "%a;%F;%S;%r;${needed}" $filename)
					newline=${newline//  -  }
					echo "${newline:3}" >> "${cpv}/NEEDED.ELF.2"
				done < "${cpv}/NEEDED"
			fi
		done
	fi

	if $REPO_LAYOUT_CONF_WARN ; then
		ewarn
		echo "If you want overlay eclasses to override eclasses from" \
			"other repos then see the portage(5) man page" \
			"for information about the new layout.conf and repos.conf" \
			"configuration files." \
			| fmt -w 75 | while read -r ; do ewarn "$REPLY" ; done
		ewarn
	fi

	if $MINOR_UPGRADE ; then
		elog "If you're upgrading from a pre-2.2 version of portage you might"
		elog "want to remerge world (emerge -e world) to take full advantage"
		elog "of some of the new features in 2.2."
		elog "This is not required however for portage to function properly."
		elog
	fi
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/portage/pym
}
