#!/bin/bash
# Find builds here:
# https://android-build.googleplex.com/builds/branches/aosp-emu-dev/grid?
set -e

if [ $# == 1 ]
then
build=$1
else
	echo  Usage: $0 build
	exit 1
fi

prebuilt_tool="/google/data/ro/projects/android/prebuilt_drop_tool/prebuilt_drop.par"

common_args=()
common_args+=(--build_id=$build)
common_args+=(--target=trusty_tee-trusty_x64)
common_args+=(--dest_host='https://android-review.googlesource.com')
common_args+=(--dest_project='platform/prebuilts/android-emulator')
common_args+=(--dest_git_branch=main)
common_args+=(--topic="trusty_qemu_build_$build")

$prebuilt_tool "${common_args[@]}" --source_dest_file_pair="manifest_$build.xml:trusty-x86_64/manifest.xml"
$prebuilt_tool "${common_args[@]}" --source_dest_file_pair="sdk-repo-trusty_x64-qemu-$build.zip:trusty-x86_64/qemu.zip" --transform='unzip' --use_git
