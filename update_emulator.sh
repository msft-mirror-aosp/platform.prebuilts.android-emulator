#!/bin/bash
# Find builds here:
# https://android-build.googleplex.com/builds/branches/aosp-emu-master-dev/grid?
set -e

function update_binaries {
	local src="$1"
	local dst="$2"

	rm -rf "$dst"
	rm -rf "emulator"
	unzip "$src"
	rm -f "./emulator/emulator64-crash-service"
	rm -f "./emulator/emulator64-mips"
	rm -f "./emulator/qemu/linux-x86_64/qemu-system-mipsel"
	rm -f "./emulator/qemu/linux-x86_64/qemu-system-mips64el"
	rm -f ./emulator/lib/*.proto
	mv "emulator" "$dst"
	git add "$dst"
}

if [ $# == 1 ]
then
  build=$1
else
  echo Usage: $0 build
  echo Find an Emulator build here: https://android-build.googleplex.com/builds/branches/aosp-emu-master-dev/grid?
  exit 1
fi

dir="$(dirname "$0")"
linux_zip="sdk-repo-linux-emulator-$build.zip"

pushd "$dir"

repo start emulator_$build
echo Fetching Emulator Linux build $build
/google/data/ro/projects/android/fetch_artifact --bid $build --target sdk_tools_linux "$linux_zip"
update_binaries "$linux_zip" "linux-x86_64"

rm -f "$linux_zip" .fetch_*

printf "Upgrade emulator to emu-master-dev build $build\n\n" > commitmsg.tmp

set +e

git commit -s -t commitmsg.tmp

rm -f "commitmsg.tmp"

popd
