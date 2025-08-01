# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MATTLAW
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Utilities for handling Byte Order Marks"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-Encode-1.990.0
	>=dev-perl/Readonly-0.60.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		>=dev-perl/Test-Exception-0.200.0
	)
"

PERL_RM_FILES=(
	"t/04..pod.t"
)
