#!/bin/bash
set -e

cd "$INPUT_EXECUTION_PATH"

echo "Latest version: $INPUT_VERSION"

mkdir -p build/"$INPUT_PACKAGE_NAME"-"$INPUT_VERSION"/debian
git tag --list "$INPUT_TAG_FILTER" --sort=-authordate \
    --format "$INPUT_PACKAGE_NAME (%(refname:lstrip=-1)) UNRELEASED; urgency=medium%0a%0a  * %(subject)%0a%0a -- %(authorname) %(authoremail)  %(authordate:rfc2822)" \
    > build/"$INPUT_PACKAGE_NAME"-"$INPUT_VERSION"/debian/changelog
echo 9 > build/"$INPUT_PACKAGE_NAME"-"$INPUT_VERSION"/debian/compat
cp -r debian/* build/"$INPUT_PACKAGE_NAME"-"$INPUT_VERSION"/debian/
cd build/"$INPUT_PACKAGE_NAME"-"$INPUT_VERSION"
if [[ "$INPUT_TARGET_ARCHITECTURE" == "amd64" ]]; then
  dpkg-buildpackage
elif [[ "$INPUT_TARGET_ARCHITECTURE" == "arm64" ]]; then
  CONFIG_SITE=/etc/dpkg-cross/cross-config.amd64 DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -aarm64 -Pcross,nocheck
fi