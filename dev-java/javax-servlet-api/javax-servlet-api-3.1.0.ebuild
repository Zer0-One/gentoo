# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.servlet:javax.servlet-api:3.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JavaServlet(TM) Specification JSR-000340"
HOMEPAGE="https://javaee.github.io/servlet-spec/"
SRC_URI="https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/${PV}/javax.servlet-api-${PV}-sources.jar"

LICENSE="CDDL GPL-2"
SLOT="3.1"
KEYWORDS="amd64 arm64 ppc64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p "${JAVA_RESOURCE_DIRS}/META-INF" || die
	echo "Implementation-Version: 3.1.0" > "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF"
	echo "Specification-Version: 3.1" >> "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF"
	find . -type f -name '*.properties' | xargs cp --parent -t resources || die
}
