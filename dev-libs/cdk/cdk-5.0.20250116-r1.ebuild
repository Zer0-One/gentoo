# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-$(ver_rs 2 -)"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="A library of curses widgets"
HOMEPAGE="https://dickey.his.com/cdk/cdk.html https://github.com/ThomasDickey/cdk-snapshots"
SRC_URI="https://invisible-island.net/archives/${PN}/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${MY_P}.tgz.asc )"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0/6.3.5" # subslot = soname version, check VERSION
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples unicode"

DEPEND="sys-libs/ncurses:=[unicode(+)?]"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

src_configure() {
	if [[ ${CHOST} == *-*-darwin* ]] ; then
		export ac_cv_prog_LIBTOOL=glibtool
	fi

	# --with-libtool dropped for now because of broken Makefile
	# bug #790773
	#
	# Fedora and openSUSE at least both build with --enable-const. Without
	# this, consumers end up broken like gphoto2 in bug #919279.
	econf \
		--disable-rpath-hack \
		--enable-const \
		--with-shared \
		--with-pkg-config \
		--enable-pc-files \
		--with-shlib-version=abi \
		--with-pkg-config-libdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig" \
		--with-ncurses$(usex unicode "w" "")
}

src_install() {
	# parallel make installs duplicate libs
	emake -j1 \
		DESTDIR="${D}" \
		DOCUMENT_DIR="${ED}/usr/share/doc/${PF}" \
		install

	if use examples ; then
		local x
		for x in include c++ demos examples cli cli/utils cli/samples ; do
			[[ -d ${x} ]] || continue
			docinto ${x}
			find ${x} -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 dodoc || die
		done
	fi

	find "${ED}" \( -name '*.a' -or -name '*.la' \) -delete || die
}
