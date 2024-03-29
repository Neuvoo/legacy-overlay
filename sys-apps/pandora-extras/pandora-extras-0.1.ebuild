# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=0

DESCRIPTION="Provides configuration for wifi, nubs, LED's, and keyboard"
HOMEPAGE=""
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/baselayout-2
	x11-apps/xmodmap"

src_install() {
	ewarn "This will only work, at all, if you have the Pandora kernel"
	ewarn "installed."
	elog
	elog "Add omaplfb and board-omap3pandora-wifi to /etc/conf.d/modules to"
	elog "autoload these drivers at boot."
	elog
	elog "The /etc/X11/xorg.conf.pandora file is a suggested configuration for"
	elog "X. Symlink to it from /etc/X11/xorg.conf:"
	elog "# ln -s /etc/X11/xorg.conf.pandora /etc/X11/xorg.conf"
	elog "...or edit /etc/X11/xorg.conf and add the parts you like from"
	elog "xorg.conf.pandora."
	elog
	elog "In order for the touchscreen to operate, uncomment the following line"
	elog "in /etc/ts.conf:"
	elog "# module_raw input"

	mkdir -p "${D}/lib/udev/rules.d/"
	cat > "${D}/lib/udev/rules.d/50-compat_firmware.rules" <<EOF || die "couldn't install 50-compat_firmware.rules"
SUBSYSTEM=="compat_firmware", ACTION=="add", RUN+="firmware.sh"
EOF

	mkdir -p "${D}/etc/X11/xinit/xinitrc.d/"
	cat > "${D}/etc/X11/xinit/xinitrc.d/01-pndkeymap" <<REOF || die "couldn't install 01-pndkeymap"
xmodmap - <<EOF
keycode   9 = Escape NoSymbol Escape
keycode  10 = 1 section 1 section
keycode  11 = 2 braceleft 2 braceleft
keycode  12 = 3 braceright 3 braceright
keycode  13 = 4 asciitilde 4 asciitilde
keycode  14 = 5 percent 5 percent
keycode  15 = 6 asciicircum 6 asciicircum
keycode  16 = 7 ampersand 7 ampersand
keycode  17 = 8 asterisk 8 asterisk
keycode  18 = 9 bracketleft 9 bracketleft
keycode  19 = 0 bracketright 0 bracketright
keycode  22 = BackSpace Delete BackSpace Delete
keycode  24 = q Q q Q
keycode  25 = w W w W
keycode  26 = e E e E
keycode  27 = r R r R
keycode  28 = t T t T
keycode  29 = y Y y Y
keycode  30 = u U u U
keycode  31 = i I i I
keycode  32 = o O o O
keycode  33 = p P p P
keycode  34 = parenleft NoSymbol parenleft
keycode  35 = parenright NoSymbol parenright
keycode  36 = Return Multi_key Return
keycode  37 = Control_L NoSymbol Control_L
keycode  38 = a A a A
keycode  39 = s S s S
keycode  40 = d D d D
keycode  41 = f F f F
keycode  42 = g G g G
keycode  43 = h H h H
keycode  44 = j J j J
keycode  45 = k K k K
keycode  46 = l L l L
keycode  47 = semicolon NoSymbol semicolon
keycode  48 = apostrophe NoSymbol apostrophe
keycode  49 = grave NoSymbol grave
keycode  50 = Shift_L NoSymbol Shift_L
keycode  52 = z Z z Z
keycode  53 = x X x X
keycode  54 = c C c C
keycode  55 = v V v V
keycode  56 = b B b B
keycode  57 = n N n N
keycode  58 = m M m M
keycode  59 = comma less comma less
keycode  60 = period greater period greater
keycode  61 = slash NoSymbol slash
keycode  62 = Shift_R NoSymbol Shift_R
keycode  64 = Alt_L NoSymbol Alt_L
keycode  65 = space NoSymbol space
keycode  66 = Caps_Lock NoSymbol Caps_Lock
keycode  67 = F1 NoSymbol F1
keycode  68 = F2 NoSymbol F2
keycode  69 = F3 NoSymbol F3
keycode  70 = F4 NoSymbol F4
keycode  71 = F5 NoSymbol F5
keycode  72 = F6 NoSymbol F6
keycode  73 = F7 NoSymbol F7
keycode  74 = F8 NoSymbol F8
keycode  75 = F9 NoSymbol F9
keycode  76 = F10 NoSymbol F10
keycode  82 = minus NoSymbol minus NoSymbol
keycode  83 = Home quotedbl Home quotedbl
keycode  86 = plus NoSymbol plus NoSymbol
keycode  87 = Prior Multi_key Prior Multi_key
keycode  88 = End XF86_Switch_VT_2 End XF86_Switch_VT_2
keycode  89 = Next XF86_Switch_VT_1 Next XF86_Switch_VT_1
keycode  95 = F11 NoSymbol F11
keycode  96 = F12 NoSymbol F12
keycode 118 = Insert NoSymbol Insert
keycode 132 = yen NoSymbol yen
keycode 187 = parenleft NoSymbol parenleft
keycode 188 = parenright NoSymbol parenright
keycode 191 = acute NoSymbol acute
keycode 192 = bar NoSymbol bar
keycode 193 = underscore NoSymbol underscore
keycode 194 = numbersign NoSymbol numbersign
keycode 195 = exclam NoSymbol exclam
keycode 196 = sterling NoSymbol sterling
keycode 197 = quotedbl NoSymbol quotedbl
keycode 198 = at NoSymbol at
keycode 199 = colon NoSymbol colon
keycode 200 = dollar NoSymbol dollar
keycode 201 = EuroSign NoSymbol EuroSign
keycode 222 = question NoSymbol question
keycode 235 = Tab NoSymbol Tab
EOF
REOF

	mkdir -p "${D}/etc/X11/xinit/xinitrc.d/"
	cat > "${D}/etc/X11/xinit/xinitrc.d/01-pndnubmice" <<EOF || die "couldn't install 01-pndnubmice"
echo mouse > /proc/pandora/nub0/mode
echo 150 > /proc/pandora/nub0/mouse_sensitivity
echo 7 > /proc/pandora/nub0/scrollx_sensitivity
echo 7 > /proc/pandora/nub0/scrolly_sensitivity
echo 20 > /proc/pandora/nub0/scroll_rate
echo 20 > /proc/pandora/nub0/mbutton_threshold
echo mbuttons > /proc/pandora/nub1/mode
echo 150 > /proc/pandora/nub1/mouse_sensitivity
echo 7 > /proc/pandora/nub1/scrollx_sensitivity
echo 7 > /proc/pandora/nub1/scrolly_sensitivity
echo 20 > /proc/pandora/nub1/scroll_rate
echo 20 > /proc/pandora/nub1/mbutton_threshold
EOF

	chmod +x "${D}/etc/X11/xinit/xinitrc.d/01-pndkeymap" || die "failed to set up permissions"
	chmod +x "${D}/etc/X11/xinit/xinitrc.d/01-pndnubmice" || die "failed to set up permissions"

	mkdir -p "${D}/etc/X11/"
	cat > "${D}/etc/X11/xorg.conf.pandora" <<EOF || die "couldn't install xorg.conf.pandora"
Section "Device"
	Identifier	"OMAP Framebuffer Device"
	Driver	"omapfb"
	Option	"ShadowFB" "false"
EndSection
EOF

	mkdir -p "${D}/etc/env.d/"
	cat > "${D}/etc/env.d/10tslib" <<EOF || die "couldn't install 10tslib"
TSLIB_TSDEVICE=/dev/input/by-path/platform-omap2_mcspi.1-event
TSLIB_CALIBFILE=/etc/pointercal
TSLIB_CONSOLEDEVICE=none
TSLIB_FBDEVICE=/dev/fb0
EOF
}
