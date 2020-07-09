#!/bin/bash
set -e

cd "$INPUT_EXECUTION_PATH"

VERSION=$(git tag --sort=-taggerdate --format "%(refname:lstrip=-1)" | head -1)
echo "Latest version: $VERSION"

mkdir -p build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian
git tag --sort=-authordate \
    --format "$INPUT_PACKAGE_NAME (%(refname:lstrip=-1)) UNRELEASED; urgency=medium%0a%0a  * %(subject)%0a%0a -- %(authorname) %(authoremail)  %(authordate:rfc2822)" \
    > build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/changelog
echo 9 > build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/compat
cp -r debian/* build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/
sed -i "s/\$VERSION/$VERSION/g" build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/control
cd build/"$INPUT_PACKAGE_NAME"-"$VERSION"
if [[ "$INPUT_TARGET_ARCHITECTURE" == "amd64" ]]; then
  dpkg-buildpackage
elif [[ "$INPUT_TARGET_ARCHITECTURE" == "arm64" ]]; then
  CONFIG_SITE=/etc/dpkg-cross/cross-config.amd64 DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -aarm64 -Pcross,nocheck
fi