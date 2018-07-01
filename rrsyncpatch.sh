#!/bin/bash

#definations
localManifestBranch=android-8.1
source=/home/acar/android/rrtreble/
rom_fp="$(date +%y%m%d)"
rom=rr
jobs=16
export RR_BUILDTYPE=Official
export days_to_log=7

mkdir -p release/$rom_fp/

#clone local_manifests from phh repo
if [ -d .repo/local_manifests ] ;then
	( cd .repo/local_manifests; git fetch; git reset --hard; git checkout origin/$localManifestBranch)
else
	git clone https://github.com/phhusson/treble_manifest .repo/local_manifests -b $localManifestBranch
fi

#dont replace with aosp sources
rm -f .repo/local_manifests/replace.xml

#reset sources, sync and patch
repo forall -j64 -c 'git reset --hard && git clean -fdx'
repo sync -c -j$jobs --force-sync
rm -f device/*/sepolicy/common/private/genfs_contexts
(cd device/phh/treble; git clean -fdx; bash generate.sh $rom)

#apply patches
bash apply-patchesrr.sh patches
