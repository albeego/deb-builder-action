#!/bin/bash
set -e

cd "$INPUT_EXECUTION_PATH"

VERSION=$(git tag --sort=-taggerdate | head -1)
echo "Latest version: $VERSION"

mkdir -p build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian
git tag --sort=-authordate --format "$INPUT_PACKAGE_NAME (%(refname:lstrip=2)) UNRELEASED; urgency=medium%0a%0a  * %(subject)%0a%0a -- %(authorname) %(authoremail)  %(authordate:rfc2822)" > build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/changelog
echo 9 > build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/compat
cp -r debian/* build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/
sed -i "s/\$VERSION/$VERSION/g" build/"$INPUT_PACKAGE_NAME"-"$VERSION"/debian/control
cd build/"$INPUT_PACKAGE_NAME"-"$VERSION"
dpkg-buildpackage