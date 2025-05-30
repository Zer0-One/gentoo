# Copyright 2018-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Secure Reliable Transport (SRT) library and tools"
HOMEPAGE="https://github.com/Haivision/srt"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Haivision/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Haivision/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv -sparc x86 ~ppc-macos ~x64-macos"
fi

LICENSE="MPL-2.0"
SLOT="0/$(ver_cut 1-2)"
IUSE="gnutls test"
RESTRICT="!test? ( test )"

RDEPEND="
	gnutls? (
		dev-libs/nettle:0=[${MULTILIB_USEDEP}]
		net-libs/gnutls:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.10[${MULTILIB_USEDEP}] )"

src_configure() {
	# ODR violations
	# https://github.com/Haivision/srt/issues/2145 (bug #861584)
	filter-lto

	local mycmakeargs=(
		-DUSE_CXX_STD=c++14 # Required for gtest
		-DENABLE_STATIC=OFF
		# Bonding is experimental in 1.5, but works good and doesn't affect anything when not enabled with API calls
		-DENABLE_BONDING=ON
		-DENABLE_UNITTESTS=$(usex test)
		-DENABLE_TESTING=OFF # Not installed developer/testing tools
		-DUSE_GNUTLS=$(usex gnutls)
	)
	cmake-multilib_src_configure
}

multilib_src_test() {
	cmake_src_test -j1
}

multilib_src_install() {
	cmake_src_install
	# remove old upstream temporary compatibility pc
	rm "${ED}/usr/$(get_libdir)/pkgconfig/haisrt.pc" || die
}
