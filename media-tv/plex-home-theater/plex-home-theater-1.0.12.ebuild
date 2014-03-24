# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils cmake-utils git-2

DESCRIPTION="For the ultimate experience, install Plex Home Theater on a dedicated computer for your TV. It's optimized for the big screen and supports a wide variety of formats with high-definition audio, native framerates, and more."
HOMEPAGE="https://plex.tv"
#SRC_URI="https://github.com/plexinc/plex-home-theater-public/archive/pht-v$PV.tar.gz"
EGIT_REPO_URI="git://github.com/plexinc/plex-home-theater-public.git"
EGIT_COMMIT="pht-v1.0.12"

SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="media-libs/freetype
	media-libs/libsdl[X,opengl]
	media-libs/sdl-image
	media-libs/sdl-mixer
	virtual/opengl
	virtual/jpeg
	>=dev-db/sqlite-3
	>=dev-libs/lzo-2
	dev-libs/fribidi
	media-libs/fontconfig
	media-libs/libsamplerate
	net-libs/libmicrohttpd[messages]
	media-libs/glew
	net-dns/avahi[dbus,python]
	x11-libs/libXrandr
	media-libs/flac
	net-misc/curl
	media-libs/libpng
	media-libs/tiff
	media-libs/libvorbis
	media-libs/libmad
	media-libs/libmpeg2
	media-libs/libass
	media-video/rtmpdump
	media-libs/libshairport
	x11-libs/libva[opengl]
	x11-libs/libvdpau
	media-libs/libmodplug
	dev-libs/libcdio
	media-sound/lame"

DEPEND="$RDEPEND
	dev-libs/yajl
	dev-libs/tinyxml
	dev-libs/boost
	app-pda/libplist"

#src_unpack() {
#	if [ "${A}" != "" ]; then
#		unpack ${A}
#		mv plex-home-theater-public-pht-v$PV $S
#	fi
#}

src_prepare() {
	epatch "${FILESDIR}/fribidi.patch"
}

src_configure() {
	local mycmakeargs="-DCOMPRESS_TEXTURES=on -DENABLE_AUTOUPDATE=off"
	cmake-utils_src_configure ${mycmakeargs} \
		|| die "cmake configuration failed"
}

pkg_preinst() {
	mkdir -p "${D}/usr/bin"
	mkdir -p "${D}/usr/share/xsessions"
	cp "${FILESDIR}/Plex.desktop" "${D}/usr/share/xsessions" || die "Unable to copy Xsession file"
	cp "${FILESDIR}/plex-standalone.sh" "${D}/usr/bin" || die "Unable to copy standalone startup script"
	chmod a+x "${D}/usr/bin/plex-standalone.sh"
}

pkg_postinst() {
	elog "Plex Home Theatre is now fully installed."
	elog "You can automatically launch it using the Plex Xsession."
}