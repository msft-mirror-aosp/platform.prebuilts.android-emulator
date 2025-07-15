#!/bin/bash
# Find builds here:
# https://android-build.googleplex.com/builds/branches/git_emu-main-next-dev/grid?
set -e

if [ $# == 1 ]
then
build=$1
else
	echo  Usage: $0 build
	exit 1
fi

manifest_xml="manifest_$build.xml"
trusty_zip="sdk-repo-trusty_x64-qemu-$build.zip"
trusty_dir="trusty-x86_64"

echo Fetching Trusty $build
/google/data/ro/projects/android/fetch_artifact --bid $build --target emulator_trusty_tee_trusty_x64 "$manifest_xml"
/google/data/ro/projects/android/fetch_artifact --bid $build --target emulator_trusty_tee_trusty_x64 "$trusty_zip"

rm -rf "$trusty_dir"
mkdir "$trusty_dir"
mv "$manifest_xml" "$trusty_dir/manifest.xml"
unzip -d "$trusty_dir" "$trusty_zip"

printf "Upgrade Trusty emulator to emu-main-next-dev build $build\n\n" > emulator.commitmsg

# Restore Android.bp since we deleted the whole directory earlier
git restore -W "$trusty_dir/Android.bp"
git add "$trusty_dir"
git commit -s -t emulator.commitmsg

rm -f "emulator.commitmsg"
rm -f "$trusty_zip"
